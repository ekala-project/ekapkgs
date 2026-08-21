# System-wide mdevctl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mdevctl;
in

{
  options.programs.mdevctl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mdevctl for mediated device management.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mdevctl;
      description = "mdevctl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."mdevctl.d/.keep".text = "";
    environment.etc."mdevctl/scripts.d/notifiers/.keep".text = "";
    environment.etc."mdevctl/scripts.d/callouts/.keep".text = "";
  };
}
