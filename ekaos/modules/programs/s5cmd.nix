# System-wide s5cmd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.s5cmd;
in

{
  options.programs.s5cmd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install s5cmd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.s5cmd;
      description = "s5cmd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
