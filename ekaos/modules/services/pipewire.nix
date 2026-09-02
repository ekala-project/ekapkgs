# PipeWire — multimedia processing service
#
# Provides audio (and optionally video) routing via PipeWire,
# replacing PulseAudio and JACK with a unified modern stack.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pipewire;
in

{
  options.services.pipewire = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the PipeWire multimedia service.";
    };

    description = mkOption {
      type = types.str;
      default = "PipeWire Multimedia Service";
      description = "Service description.";
    };

    command = mkOption {
      type = types.str;
      internal = true;
      description = "Command to run (set automatically).";
    };

    args = mkOption {
      type = types.listOf types.str;
      internal = true;
      default = [ ];
      description = "Command arguments (set automatically).";
    };

    user = mkOption {
      type = types.str;
      default = "";
      description = "User to run PipeWire as (empty for user service).";
    };

    restartPolicy = mkOption {
      type = types.str;
      default = "on-failure";
      description = "Restart policy.";
    };

    systemd = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Systemd-specific options.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pipewire;
      description = "PipeWire package to use.";
    };

    audio.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to use PipeWire as the primary audio server.";
    };

    alsa = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable ALSA compatibility.";
      };

      support32Bit = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable 32-bit ALSA compatibility on 64-bit systems.";
      };
    };

    pulse.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable PulseAudio compatibility.";
    };

    jack.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable JACK compatibility.";
    };

    wireplumber = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable WirePlumber as the session manager.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.wireplumber;
        description = "WirePlumber package to use.";
      };
    };
  };

  config = mkIf cfg.enable {
    # Define the PipeWire service using cross-platform interface
    services.pipewire = {
      command = "${cfg.package}/bin/pipewire";
      args = [ ];
      restartPolicy = "on-failure";

      systemd = {
        after = [ "graphical-session.target" ];
        wantedBy = [ "default.target" ];
      };
    };

    environment.systemPackages = [
      cfg.package
    ]
    ++ lib.optional cfg.wireplumber.enable cfg.wireplumber.package;

    # PipeWire systemd user service
    systemd.user.services.pipewire = {
      description = cfg.description;
      after = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/pipewire";
        Restart = cfg.restartPolicy;
        RestartSec = 5;
        Type = "simple";
        Slice = "session.slice";
      };
    };

    # PipeWire socket activation
    systemd.user.sockets.pipewire = {
      description = "PipeWire Multimedia System Socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "%t/pipewire-0" ];
      socketConfig = {
        SocketMode = "0600";
      };
    };

    # PulseAudio compatibility service
    systemd.user.services.pipewire-pulse = mkIf cfg.pulse.enable {
      description = "PipeWire PulseAudio Compatibility";
      after = [ "pipewire.service" ];
      bindsTo = [ "pipewire.service" ];
      wantedBy = [ "pipewire.service" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/pipewire-pulse";
        Restart = cfg.restartPolicy;
        RestartSec = 5;
        Type = "simple";
        Slice = "session.slice";
      };
    };

    systemd.user.sockets.pipewire-pulse = mkIf cfg.pulse.enable {
      description = "PipeWire PulseAudio Socket";
      wantedBy = [ "sockets.target" ];
      listenStreams = [ "%t/pulse/native" ];
      socketConfig = {
        SocketMode = "0600";
      };
    };

    # WirePlumber session manager
    systemd.user.services.wireplumber = mkIf cfg.wireplumber.enable {
      description = "WirePlumber Session Manager";
      after = [ "pipewire.service" ];
      bindsTo = [ "pipewire.service" ];
      wantedBy = [ "pipewire.service" ];
      serviceConfig = {
        ExecStart = "${cfg.wireplumber.package}/bin/wireplumber";
        Restart = cfg.restartPolicy;
        RestartSec = 5;
        Type = "simple";
        Slice = "session.slice";
      };
    };

    # Session variables for audio routing
    environment.sessionVariables = mkIf cfg.audio.enable {
      SDL_AUDIODRIVER = "pipewire";
    };
  };
}
