# ALSA — Advanced Linux Sound Architecture
#
# Provides the user-space side of ALSA: device configuration, persistence,
# OSS emulation, Bluetooth audio (BlueALSA), and softvol controls.
# Enable this only when using ALSA directly — not with PipeWire or PulseAudio.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.hardware.alsa;

  quote = x: ''"${lib.escape [ "\"" ] x}"'';

  alsactl = lib.getExe' pkgs.alsa-utils "alsactl";

  mkControl = name: opts: ''
    pcm.${name} {
      type softvol
      slave.pcm ${quote opts.device}
      control.name ${quote (if opts.name != null then opts.name else name)}
      control.card ${quote opts.card}
      max_dB ${toString opts.maxVolume}
    }
  '';

  cardsConfig =
    let
      drivers = lib.unique (lib.mapAttrsToList (n: v: v.driver) cfg.cardAliases);
      options = lib.forEach drivers (
        drv:
        let
          byDriver = lib.filterAttrs (n: v: v.driver == drv);
          ids = lib.mapAttrs (n: v: v.id) (byDriver cfg.cardAliases);
        in
        {
          driver = drv;
          names = lib.attrNames ids;
          ids = lib.attrValues ids;
        }
      );
      toList = x: lib.concatStringsSep "," (map toString x);
    in
    lib.forEach options (i: "options ${i.driver} index=${toList i.ids} id=${toList i.names}");

  pluginsPath = pkgs.symlinkJoin {
    name = "alsa-with-plugins";
    paths = cfg.plugins;
  };

  alsaVariables = {
    "ALSA_AUDIO_OUT" = cfg.defaultDevice.playback;
    "ALSA_AUDIO_IN" = cfg.defaultDevice.capture;
    "ALSA_PLUGIN_DIR" = lib.mkIf (cfg.plugins != [ ]) "${pluginsPath}/lib/alsa-lib";
  };
in

{
  options.hardware.alsa = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to set up the user space part of the Advanced Linux Sound
        Architecture (ALSA).  Enable this only if you want to use ALSA as
        your main sound system, not if you are using PipeWire or PulseAudio.
      '';
    };

    enableOSSEmulation = mkEnableOption "the OSS emulation";

    enableBluetooth = mkEnableOption "Bluetooth audio support via BlueALSA";

    enableRecorder = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to set up a loopback device that continuously records and
        allows playback of audio from the computer.  The loopback device
        is named pcm.recorder.
      '';
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "List of ALSA plugins to add to the search path.";
    };

    defaultDevice.playback = mkOption {
      type = types.str;
      default = "";
      example = "dmix:CARD=1,DEV=0";
      description = ''
        The default playback device.  Leave empty to let ALSA pick
        automatically.  Can be overridden at runtime via ALSA_AUDIO_OUT.
      '';
    };

    defaultDevice.capture = mkOption {
      type = types.str;
      default = "";
      example = "dsnoop:CARD=0,DEV=2";
      description = ''
        The default capture device (microphone).  Leave empty to let ALSA
        pick automatically.  Can be overridden at runtime via ALSA_AUDIO_IN.
      '';
    };

    controls = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.name = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Name of the control as shown in alsamixer.";
          };
          options.device = mkOption {
            type = types.str;
            default = "default";
            description = "PCM device to control (slave).";
          };
          options.card = mkOption {
            type = types.str;
            default = "default";
            description = "PCM card to control (slave).";
          };
          options.maxVolume = mkOption {
            type = types.float;
            default = 0.0;
            description = "Maximum volume in dB.";
          };
        }
      );
      default = { };
      description = "Virtual volume controls (softvols) to add to a sound card.";
    };

    cardAliases = mkOption {
      type = types.attrsOf (
        types.submodule {
          options.driver = mkOption {
            type = types.str;
            description = "Name of the kernel module that provides the card.";
          };
          options.id = mkOption {
            type = types.int;
            default = 0;
            description = "The ID of the sound card.";
          };
        }
      );
      default = { };
      description = "Assign custom names and reorder sound cards.";
    };

    deviceAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Assign custom names to sound devices.";
    };

    config = mkOption {
      type = types.lines;
      default = "";
      description = "Content of the system-wide ALSA configuration (/etc/asound.conf).";
    };

    enablePersistence = mkOption {
      type = types.bool;
      default = config.hardware.alsa.enable;
      description = "Whether to enable ALSA sound card state saving on shutdown.";
    };
  };

  config = mkMerge [

    (mkIf cfg.enable {
      # Conflict with sound servers enabled by default
      services.pipewire.enable = mkDefault false;

      hardware.alsa.config =
        let
          conf = [
            ''
              pcm.!default fromenv

              pcm.fromenv {
                type asym
                playback.pcm {
                  type plug
                  slave.pcm {
                    @func getenv
                    vars [ ALSA_AUDIO_OUT ]
                    default pcm.sysdefault
                  }
                }
                capture.pcm {
                  type plug
                  slave.pcm {
                    @func getenv
                    vars [ ALSA_AUDIO_IN ]
                    default pcm.sysdefault
                  }
                }
              }
            ''
            (lib.optional cfg.enableRecorder ''
              pcm.!default "splitter:fromenv,recorder"

              pcm.splitter {
                @args [ A B ]
                @args.A.type string
                @args.B.type string
                type asym
                playback.pcm {
                  type plug
                  route_policy "duplicate"
                  slave.pcm {
                    type multi
                    slaves.a.pcm $A
                    slaves.b.pcm $B
                    slaves.a.channels 2
                    slaves.b.channels 2
                    bindings [
                     { slave a channel 0 }
                     { slave a channel 1 }
                     { slave b channel 0 }
                     { slave b channel 1 }
                    ]
                  }
                }
                capture.pcm $A
              }

              pcm.recorder {
                type asym
                capture.pcm {
                  type dsnoop
                  ipc_key 9165218
                  ipc_perm 0666
                  slave.pcm "hw:loopback,1,0"
                  slave.period_size 1024
                  slave.buffer_size 8192
                }
                playback.pcm {
                  type dmix
                  ipc_key 6181923
                  ipc_perm 0666
                  slave.pcm "hw:loopback,0,0"
                  slave.period_size 1024
                  slave.buffer_size 8192
                }
              }
            '')
            (lib.mapAttrsToList mkControl cfg.controls)
            (lib.mapAttrsToList (n: v: "pcm.${n} ${quote v}") cfg.deviceAliases)
          ];
        in
        mkBefore (lib.concatStringsSep "\n" (lib.flatten conf));

      hardware.alsa.cardAliases = mkIf cfg.enableRecorder {
        loopback.driver = "snd_aloop";
        loopback.id = 2;
      };

      environment.sessionVariables = alsaVariables;

      environment.etc."asound.conf".text = cfg.config;

      boot.kernelModules =
        [ ]
        ++ lib.optionals cfg.enableOSSEmulation [
          "snd_pcm_oss"
          "snd_mixer_oss"
        ]
        ++ lib.optionals cfg.enableRecorder [ "snd_aloop" ];

      boot.extraModprobeConfig = lib.concatStringsSep "\n" cardsConfig;

      environment.systemPackages = [ pkgs.alsa-utils ];
    })

    (mkIf (cfg.enable && cfg.enableBluetooth) {
      users.users.bluealsa = {
        description = "BlueALSA daemons user";
        isSystemUser = true;
        group = "audio";
      };

      environment.etc."alsa/conf.d/20-bluealsa.conf".source =
        "${pkgs.bluez-alsa}/etc/alsa/conf.d/20-bluealsa.conf";

      hardware.alsa.plugins = [ pkgs.bluez-alsa ];

      environment.systemPackages = [ pkgs.bluez-alsa ];
      systemd.packages = [ pkgs.bluez-alsa ];

      systemd.services."bluealsa".wantedBy = [ "bluetooth.target" ];
    })

    (mkIf cfg.enablePersistence {
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="sound", KERNEL=="controlC*", KERNELS!="card*", GOTO="alsa_restore_go"
        GOTO="alsa_restore_end"

        LABEL="alsa_restore_go"
        TEST!="/etc/alsa/state-daemon.conf", RUN+="${alsactl} restore -gU $attr{device/number}"
        TEST=="/etc/alsa/state-daemon.conf", RUN+="${alsactl} nrestore -gU $attr{device/number}"
        LABEL="alsa_restore_end"
      '';

      systemd.services.alsa-store = {
        description = "Store Sound Card State";
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;
        unitConfig = {
          RequiresMountsFor = "/var/lib/alsa";
          ConditionVirtualization = "!systemd-nspawn";
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          StateDirectory = "alsa";
          SuccessExitStatus = [
            0
            99
          ];
          ExecStart = "${alsactl} restore -gU";
          ExecStop = "${alsactl} store -gU";
        };
      };
    })
  ];
}
