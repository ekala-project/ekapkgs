# System-wide asdf-vm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asdf-vm;
in

{
  options.programs.asdf-vm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asdf-vm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asdf-vm;
      description = "asdf-vm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
