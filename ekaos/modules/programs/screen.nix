# System-wide GNU Screen configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.screen;
in

{
  options.programs.screen = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install GNU Screen system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.screen;
      description = "GNU Screen package to use.";
    };

    screenrc = mkOption {
      type = types.lines;
      default = "";
      description = ''
        System-wide screenrc configuration written to /etc/screenrc.
        See screen(1) for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."screenrc" = mkIf (cfg.screenrc != "") {
      text = cfg.screenrc;
    };
  };
}
