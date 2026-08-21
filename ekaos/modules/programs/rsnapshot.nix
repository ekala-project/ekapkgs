# System-wide rsnapshot configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rsnapshot;
in

{
  options.programs.rsnapshot = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rsnapshot system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rsnapshot;
      description = "rsnapshot package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
