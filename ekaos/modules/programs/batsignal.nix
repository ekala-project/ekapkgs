# System-wide batsignal configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.batsignal;
in

{
  options.programs.batsignal = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install batsignal system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.batsignal;
      description = "batsignal package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
