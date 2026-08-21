# System-wide cargo-about configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-about;
in

{
  options.programs.cargo-about = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-about system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-about;
      description = "cargo-about package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
