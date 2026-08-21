# System-wide zathura configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.zathura;
in

{
  options.programs.zathura = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install zathura system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zathura;
      description = "zathura package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
