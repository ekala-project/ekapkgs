# System-wide rxvt-unicode configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rxvt-unicode;
in

{
  options.programs.rxvt-unicode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rxvt-unicode system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rxvt-unicode-unwrapped;
      description = "rxvt-unicode package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "X resources configuration lines for rxvt-unicode.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."X11/Xresources.d/rxvt-unicode" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
