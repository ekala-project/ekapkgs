# System-wide i3 configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.i3;
in

{
  options.programs.i3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install i3 system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.i3;
      description = "i3 package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/i3/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."i3/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
