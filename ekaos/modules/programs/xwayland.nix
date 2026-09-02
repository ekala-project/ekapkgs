# XWayland — X server for interfacing X11 apps with the Wayland protocol
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xwayland;
in

{
  options.programs.xwayland = {
    enable = mkEnableOption "XWayland (X server for interfacing X11 apps with Wayland)";

    defaultFontPath = mkOption {
      type = types.str;
      default = "";
      description = ''
        Default font path for XWayland. Setting this causes XWayland to be rebuilt.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xwayland.override { inherit (cfg) defaultFontPath; };
      description = "XWayland package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Needed by some applications for fonts and default settings
    environment.pathsToLink = [ "/share/X11" ];

    environment.systemPackages = [ cfg.package ];
  };
}
