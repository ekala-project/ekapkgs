# System-wide wlr-randr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.wlr-randr;
in

{
  options.programs.wlr-randr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install wlr-randr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.wlr-randr;
      description = "wlr-randr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
