# System-wide anchor configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.anchor;
in

{
  options.programs.anchor = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install anchor system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.anchor;
      description = "anchor package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
