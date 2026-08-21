# System-wide cargo-readme configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-readme;
in

{
  options.programs.cargo-readme = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-readme system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-readme;
      description = "cargo-readme package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
