# System-wide cargo-machete configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-machete;
in

{
  options.programs.cargo-machete = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-machete system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-machete;
      description = "cargo-machete package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
