# System-wide mutt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mutt;
in

{
  options.programs.mutt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mutt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mutt;
      description = "mutt package to use.";
    };

    muttrc = mkOption {
      type = types.lines;
      default = "";
      description = "System-wide muttrc configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."Muttrc" = mkIf (cfg.muttrc != "") {
      text = cfg.muttrc;
    };
  };
}
