# System-wide impala configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.impala;
in

{
  options.programs.impala = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install impala system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.impala;
      description = "impala package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
