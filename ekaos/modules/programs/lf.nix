# System-wide lf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lf;
in

{
  options.programs.lf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lf;
      description = "lf package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra lfrc configuration lines.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."lf/lfrc".text = mkIf (cfg.extraConfig != "") cfg.extraConfig;
  };
}
