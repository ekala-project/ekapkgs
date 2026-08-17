# System-wide krew configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.krew;
in

{
  options.programs.krew = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install krew system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.krew;
      description = "krew package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
