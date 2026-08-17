# System-wide aragorn configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aragorn;
in

{
  options.programs.aragorn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aragorn system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aragorn;
      description = "aragorn package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
