# Per-user cliphist clipboard history daemon (Wayland)
#
# Extends home.users.<name> with cliphist options.
# Creates a systemd user unit that watches the Wayland clipboard
# via wl-paste and stores history with cliphist.
#
# Usage:
#   home.users.alice.services.cliphist = {
#     enable = true;
#     maxItems = 1000;
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    literalExpression
    ;

  cliphistOpts =
    { config, ... }:
    let
      cfg = config.services.cliphist;
    in
    {
      options.services.cliphist = {
        enable = mkEnableOption "cliphist clipboard history for Wayland";

        package = mkOption {
          type = types.package;
          default = pkgs.cliphist;
          defaultText = literalExpression "pkgs.cliphist";
          description = "The cliphist package to use.";
        };

        maxItems = mkOption {
          type = types.int;
          default = 750;
          description = "Maximum number of clipboard history items to store.";
        };
      };

      config = mkIf cfg.enable {
        packages = [
          cfg.package
          pkgs.wl-clipboard
        ];

        file.".config/systemd/user/cliphist.service".text = ''
          [Unit]
          Description=Cliphist clipboard history daemon
          After=graphical-session.target
          PartOf=graphical-session.target

          [Service]
          Type=simple
          ExecStart=${pkgs.wl-clipboard}/bin/wl-paste --watch ${cfg.package}/bin/cliphist store -max-items ${toString cfg.maxItems}
          Restart=on-failure
          RestartSec=3

          [Install]
          WantedBy=graphical-session.target
        '';
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule cliphistOpts);
  };
}
