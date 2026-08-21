# System-wide Starship prompt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.starship;
  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "starship.toml" cfg.settings;
in

{
  options.programs.starship = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Starship prompt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.starship;
      description = "Starship package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Starship configuration written to /etc/starship.toml in TOML format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."starship.toml" = mkIf (cfg.settings != { }) {
      source = settingsFile;
    };

    programs.bash.interactiveInit = ''
      if [[ $TERM != "dumb" ]]; then
        ${optionalString (cfg.settings != { }) "export STARSHIP_CONFIG=/etc/starship.toml"}
        eval "$(${cfg.package}/bin/starship init bash)"
      fi
    '';
  };
}
