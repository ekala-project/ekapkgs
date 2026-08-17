# System-wide gping configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gping;
in

{
  options.programs.gping = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gping system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gping;
      description = "gping package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
