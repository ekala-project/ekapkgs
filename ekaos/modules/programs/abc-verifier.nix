# System-wide abc-verifier configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.abc-verifier;
in

{
  options.programs.abc-verifier = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install abc-verifier system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.abc-verifier;
      description = "abc-verifier package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
