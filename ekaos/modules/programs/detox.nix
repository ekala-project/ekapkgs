# System-wide detox configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.detox;
in

{
  options.programs.detox = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install detox system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.detox;
      description = "detox package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
