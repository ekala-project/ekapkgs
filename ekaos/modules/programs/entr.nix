# System-wide entr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.entr;
in

{
  options.programs.entr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install entr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.entr;
      description = "entr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
