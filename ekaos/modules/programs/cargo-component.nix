# System-wide cargo-component configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-component;
in

{
  options.programs.cargo-component = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-component system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-component;
      description = "cargo-component package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
