# System-wide acpilight configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.acpilight;
in

{
  options.programs.acpilight = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install acpilight system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.acpilight;
      description = "acpilight package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
