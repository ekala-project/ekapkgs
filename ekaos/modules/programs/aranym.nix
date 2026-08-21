# System-wide aranym configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aranym;
in

{
  options.programs.aranym = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aranym system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aranym;
      description = "aranym package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
