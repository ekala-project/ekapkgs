# System-wide binocle configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.binocle;
in

{
  options.programs.binocle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install binocle system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.binocle;
      description = "binocle package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
