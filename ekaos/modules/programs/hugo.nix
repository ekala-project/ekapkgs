# System-wide hugo configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hugo;
in

{
  options.programs.hugo = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hugo system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hugo;
      description = "hugo package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
