# Per-user darkman dark/light mode switcher
#
# Extends home.users.<name> with darkman options.
# Generates ~/.config/darkman/config.yaml, dark/light mode scripts
# under ~/.local/share/dark-mode.d/ and ~/.local/share/light-mode.d/,
# and a systemd user unit for automatic mode switching.
#
# Usage:
#   home.users.alice.services.darkman = {
#     enable = true;
#     settings = {
#       lat = 48.86;
#       lng = 2.35;
#       usegeoclue = false;
#     };
#     darkModeScripts = {
#       gtk-theme = ''
#         ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
#       '';
#     };
#     lightModeScripts = {
#       gtk-theme = ''
#         ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
#       '';
#     };
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    mapAttrs'
    nameValuePair
    literalExpression
    ;

  darkmanOpts =
    { config, ... }:
    let
      cfg = config.services.darkman;

      yamlFormat = pkgs.formats.yaml { };

      configFile = yamlFormat.generate "darkman-config.yaml" cfg.settings;

      # Generate script file entries for dark-mode.d and light-mode.d
      darkScriptFiles = mapAttrs' (
        name: text:
        nameValuePair ".local/share/dark-mode.d/${name}.sh" {
          inherit text;
          executable = true;
        }
      ) cfg.darkModeScripts;

      lightScriptFiles = mapAttrs' (
        name: text:
        nameValuePair ".local/share/light-mode.d/${name}.sh" {
          inherit text;
          executable = true;
        }
      ) cfg.lightModeScripts;
    in
    {
      options.services.darkman = {
        enable = mkEnableOption "darkman dark/light mode switcher";

        package = mkOption {
          type = types.package;
          default = pkgs.darkman;
          defaultText = literalExpression "pkgs.darkman";
          description = "The darkman package to use.";
        };

        settings = mkOption {
          type = yamlFormat.type;
          default = { };
          description = ''
            Configuration for darkman in YAML format.
            See darkman(1) for available options.
          '';
          example = literalExpression ''
            {
              lat = 48.86;
              lng = 2.35;
              usegeoclue = false;
            }
          '';
        };

        darkModeScripts = mkOption {
          type = types.attrsOf types.lines;
          default = { };
          description = ''
            Scripts to run when switching to dark mode.
            Each attribute name becomes a script file in
            ~/.local/share/dark-mode.d/<name>.sh.
          '';
          example = literalExpression ''
            {
              gtk-theme = '''
                dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
              ''';
            }
          '';
        };

        lightModeScripts = mkOption {
          type = types.attrsOf types.lines;
          default = { };
          description = ''
            Scripts to run when switching to light mode.
            Each attribute name becomes a script file in
            ~/.local/share/light-mode.d/<name>.sh.
          '';
          example = literalExpression ''
            {
              gtk-theme = '''
                dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
              ''';
            }
          '';
        };
      };

      config = mkIf cfg.enable (mkMerge [
        {
          packages = [ cfg.package ];

          file.".config/darkman/config.yaml".source = configFile;

          file.".config/systemd/user/darkman.service".text = ''
            [Unit]
            Description=Darkman dark/light mode switcher
            Documentation=man:darkman(1)
            After=graphical-session.target
            PartOf=graphical-session.target

            [Service]
            Type=dbus
            BusName=nl.whynothugo.darkman
            ExecStart=${cfg.package}/bin/darkman run
            Restart=on-failure

            [Install]
            WantedBy=graphical-session.target
          '';
        }

        { file = darkScriptFiles; }
        { file = lightScriptFiles; }
      ]);
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule darkmanOpts);
  };
}
