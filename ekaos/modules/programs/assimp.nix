# System-wide assimp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.assimp;
in

{
  options.programs.assimp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install assimp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.assimp;
      description = "assimp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
