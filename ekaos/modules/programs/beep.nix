# System-wide beep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.beep;
in

{
  options.programs.beep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install beep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.beep;
      description = "beep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
