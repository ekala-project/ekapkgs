# System-wide apko configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apko;
in

{
  options.programs.apko = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apko system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apko;
      description = "apko package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
