# System-wide Yazi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.yazi;
  tomlFormat = pkgs.formats.toml { };
  settingsFile = tomlFormat.generate "yazi.toml" cfg.settings;
in

{
  options.programs.yazi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install Yazi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yazi;
      description = "Yazi package to use.";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to add a shell wrapper function for cd-on-exit.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "Yazi configuration written to yazi.toml in TOML format.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."yazi/yazi.toml".source = mkIf (cfg.settings != { }) settingsFile;

    environment.variables.YAZI_CONFIG_HOME = mkIf (cfg.settings != { }) "/etc/yazi";

    programs.bash.interactiveInit = mkIf cfg.enableBashIntegration ''
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        ${cfg.package}/bin/yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
  };
}
