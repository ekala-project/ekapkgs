# System-wide greetd login manager configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.greetd;
in

{
  options.programs.greetd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install greetd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.greetd;
      description = "greetd package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "greetd TOML config.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.package ];
    }

    (mkIf (cfg.extraConfig != "") {
      environment.etc."greetd/config.toml".text = cfg.extraConfig;
    })
  ]);
}
