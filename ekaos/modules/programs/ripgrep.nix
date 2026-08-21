# System-wide ripgrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ripgrep;
in

{
  options.programs.ripgrep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ripgrep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ripgrep;
      description = "ripgrep package to use.";
    };

    arguments = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "--smart-case"
        "--hidden"
        "--glob=!.git"
      ];
      description = "Default arguments for rg, written to the global ripgrep config file.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."ripgreprc" = mkIf (cfg.arguments != [ ]) {
      text = concatStringsSep "\n" cfg.arguments + "\n";
    };

    environment.variables = mkIf (cfg.arguments != [ ]) {
      RIPGREP_CONFIG_PATH = "/etc/ripgreprc";
    };
  };
}
