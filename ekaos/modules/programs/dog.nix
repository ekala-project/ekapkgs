# System-wide dog configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dog;
in

{
  options.programs.dog = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dog system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dog;
      description = "dog package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
