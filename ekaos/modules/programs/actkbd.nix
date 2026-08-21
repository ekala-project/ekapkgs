# System-wide actkbd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.actkbd;
in

{
  options.programs.actkbd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install actkbd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.actkbd;
      description = "actkbd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
