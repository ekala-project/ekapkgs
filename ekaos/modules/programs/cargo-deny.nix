# System-wide cargo-deny configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-deny;
in

{
  options.programs.cargo-deny = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-deny system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-deny;
      description = "cargo-deny package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
