# System-wide hexyl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hexyl;
in

{
  options.programs.hexyl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hexyl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hexyl;
      description = "hexyl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
