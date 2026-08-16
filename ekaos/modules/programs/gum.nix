# System-wide gum configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gum;
in

{
  options.programs.gum = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gum system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gum;
      description = "gum package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
