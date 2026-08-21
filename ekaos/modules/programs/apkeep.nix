# System-wide apkeep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apkeep;
in

{
  options.programs.apkeep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apkeep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apkeep;
      description = "apkeep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
