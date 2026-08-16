# System-wide Oh My Posh configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.oh-my-posh;
  jsonFormat = pkgs.formats.json { };
  settingsFile = jsonFormat.generate "oh-my-posh-config.json" cfg.settings;
in

{
  options.programs.oh-my-posh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Oh My Posh system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.oh-my-posh;
      description = "Oh My Posh package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Oh My Posh configuration in JSON format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."oh-my-posh/config.json".source = mkIf (cfg.settings != { }) settingsFile;

    programs.bash.interactiveInit = ''
      if [[ $TERM != "dumb" ]]; then
        eval "$(${cfg.package}/bin/oh-my-posh init bash${
          optionalString (cfg.settings != { }) " --config /etc/oh-my-posh/config.json"
        })"
      fi
    '';
  };
}
