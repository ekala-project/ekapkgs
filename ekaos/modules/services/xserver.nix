# X.org display server service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver;

  # Generate xorg.conf from module options
  xorgConf = pkgs.writeText "xorg.conf" ''
    Section "ServerFlags"
      ${cfg.serverFlagsSection}
    EndSection

    Section "ServerLayout"
      Identifier "Layout"
      Screen "Screen0"
    EndSection

    Section "InputClass"
      Identifier "Keyboard catchall"
      MatchIsKeyboard "on"
      Option "XkbLayout" "${cfg.xkb.layout}"
      Option "XkbVariant" "${cfg.xkb.variant}"
      Option "XkbOptions" "${cfg.xkb.options}"
      Option "XkbModel" "${cfg.xkb.model}"
    EndSection

    ${optionalString cfg.libinput.enable ''
      Section "InputClass"
        Identifier "libinput touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
      EndSection
    ''}

    ${concatMapStringsSep "\n" (driver: ''
      Section "Device"
        Identifier "Device-${driver}"
        Driver "${driver}"
      EndSection
    '') cfg.videoDrivers}

    Section "Screen"
      Identifier "Screen0"
      DefaultDepth ${toString cfg.defaultDepth}
      ${optionalString (cfg.resolutions != [ ]) ''
        SubSection "Display"
          Depth ${toString cfg.defaultDepth}
          Modes ${concatMapStringsSep " " (res: ''"${toString res.x}x${toString res.y}"'') cfg.resolutions}
        EndSubSection
      ''}
    EndSection

    ${cfg.extraConfig}
  '';

  # Compute args, conditionally adding -dpi
  serverArgs = [
    ":0"
    "vt7"
    "-logfile"
    "/var/log/X.0.log"
    "-config"
    "/etc/X11/xorg.conf"
    "-nolisten"
    "tcp"
  ]
  ++ optionals (cfg.dpi != null) [
    "-dpi"
    (toString cfg.dpi)
  ];

in

{
  options.services.xserver = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the X.org display server.";
    };

    description = mkOption {
      type = types.str;
      default = "X.org Display Server";
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
      default = "root";
      description = "User to run the X server as.";
    };

    restartPolicy = mkOption {
      type = types.str;
      default = "always";
      description = "Restart policy.";
    };

    systemd = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Systemd-specific options.";
    };

    environment = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Environment variables (set automatically).";
    };

    ports = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Port contracts for this service.";
    };

    autorun = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to start the X server automatically on boot.";
    };

    exportConfiguration = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to export the generated xorg.conf for inspection.";
    };

    xkb = {
      layout = mkOption {
        type = types.str;
        default = "us";
        description = "Keyboard layout (XKB layout name).";
      };

      variant = mkOption {
        type = types.str;
        default = "";
        description = "Keyboard variant (XKB variant name).";
      };

      options = mkOption {
        type = types.str;
        default = "";
        description = "X keyboard options (e.g. \"ctrl:nocaps\").";
      };

      model = mkOption {
        type = types.str;
        default = "pc105";
        description = "Keyboard model (XKB model name).";
      };
    };

    videoDrivers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "modesetting"
        "nvidia"
      ];
      description = ''
        Video drivers to configure in xorg.conf.
        An empty list lets X auto-detect the appropriate driver.
      '';
    };

    modules = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = ''
        Additional X server extension modules to include
        in the module path.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra sections to append to xorg.conf verbatim.";
    };

    serverFlagsSection = mkOption {
      type = types.lines;
      default = "";
      example = ''
        Option "DontZap" "true"
        Option "BlankTime" "0"
      '';
      description = "Contents of the ServerFlags section in xorg.conf.";
    };

    defaultDepth = mkOption {
      type = types.int;
      default = 24;
      description = "Default color depth for the X server.";
    };

    resolutions = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = [ ];
      example = [
        {
          x = 1920;
          y = 1080;
        }
        {
          x = 1280;
          y = 720;
        }
      ];
      description = "List of screen resolutions. Each entry should have x and y attributes.";
    };

    libinput = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use libinput for input device management.";
      };
    };

    dpi = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 96;
      description = "DPI (dots per inch) value for the X server. Null for auto-detection.";
    };
  };

  config = mkIf cfg.enable {
    # Define the X server service contract
    services.xserver = {
      command = "${pkgs.xorg.xorgserver}/bin/X";
      args = serverArgs;
      user = "root";
      restartPolicy = "always";

      systemd = {
        after = [ "systemd-udev-settle.service" ];
        wantedBy = mkIf cfg.autorun [ "graphical.target" ];
      };
    };

    # Write xorg.conf via environment.etc
    environment.etc."X11/xorg.conf" = {
      text = builtins.readFile xorgConf;
      mode = "0644";
    };

    # Install X.org utilities
    environment.systemPackages = [
      pkgs.xorg.xorgserver
      pkgs.xauth
      pkgs.xorg.xinit
      pkgs.xrandr
      pkgs.xset
      pkgs.xkbcomp
      pkgs.xkeyboard-config
    ]
    ++ cfg.modules
    ++ optional cfg.libinput.enable pkgs.xorg.xf86inputlibinput;

    # Load kernel modules commonly needed for graphics
    boot.kernelModules = [ "i2c_dev" ];

    # Create required directories
    system.activationScripts.xserver = stringAfter [ "etc" ] ''
      mkdir -p /var/log
      mkdir -p /tmp/.X11-unix
      chmod 1777 /tmp/.X11-unix
    '';
  };
}
