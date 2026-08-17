# System-wide cargo-show-asm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-show-asm;
in

{
  options.programs.cargo-show-asm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-show-asm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-show-asm;
      description = "cargo-show-asm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
