# System-wide pngquant configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pngquant;
in

{
  options.programs.pngquant = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pngquant system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pngquant;
      description = "pngquant package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
