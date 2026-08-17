# System-wide ldns configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ldns;
in

{
  options.programs.ldns = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ldns system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ldns;
      description = "ldns package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
