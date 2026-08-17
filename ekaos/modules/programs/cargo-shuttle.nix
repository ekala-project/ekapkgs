# System-wide cargo-shuttle configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-shuttle;
in

{
  options.programs.cargo-shuttle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-shuttle system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-shuttle;
      description = "cargo-shuttle package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
