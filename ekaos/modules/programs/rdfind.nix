# System-wide rdfind configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rdfind;
in

{
  options.programs.rdfind = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rdfind system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rdfind;
      description = "rdfind package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
