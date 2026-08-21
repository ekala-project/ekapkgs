# System-wide csvtk configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.csvtk;
in

{
  options.programs.csvtk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install csvtk system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.csvtk;
      description = "csvtk package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
