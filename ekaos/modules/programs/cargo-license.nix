# System-wide cargo-license configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-license;
in

{
  options.programs.cargo-license = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-license system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-license;
      description = "cargo-license package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
