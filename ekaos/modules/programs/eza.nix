# System-wide eza configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.eza;
  optStr = optionalString (cfg.extraOptions != [ ]) (" " + concatStringsSep " " cfg.extraOptions);
in

{
  options.programs.eza = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install eza system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.eza;
      description = "eza package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to alias ls commands to eza.";
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "--group-directories-first"
        "--header"
      ];
      description = "Extra command-line options appended to eza aliases.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.shellAliases = mkIf cfg.enableBashIntegration {
      ls = "eza" + optStr;
      ll = "eza -l" + optStr;
      la = "eza -la" + optStr;
      lt = "eza --tree" + optStr;
    };
  };
}
