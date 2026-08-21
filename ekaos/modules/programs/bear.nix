# System-wide bear configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bear;
in

{
  options.programs.bear = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bear system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bear;
      description = "bear package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
