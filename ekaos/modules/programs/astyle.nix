# System-wide astyle configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.astyle;
in

{
  options.programs.astyle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install astyle system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.astyle;
      description = "astyle package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
