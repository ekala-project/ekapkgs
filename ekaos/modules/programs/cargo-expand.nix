# System-wide cargo-expand configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-expand;
in

{
  options.programs.cargo-expand = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-expand system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-expand;
      description = "cargo-expand package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
