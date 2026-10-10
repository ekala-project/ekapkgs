# Per-user htop configuration
#
# Extends home.users.<name> with htop options.
# Generates ~/.config/htop/htoprc from settings.
#
# Usage:
#   home.users.alice.programs.htop = {
#     enable = true;
#     settings = {
#       hide_kernel_threads = 1;
#       hide_userland_threads = 1;
#       tree_view = 1;
#     };
#   };
{ lib, pkgs, ... }:

let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    concatStringsSep
    mapAttrsToList
    ;

  htopOpts =
    { config, ... }:
    let
      cfg = config.programs.htop;
    in
    {
      options.programs.htop = {
        enable = mkEnableOption "per-user htop configuration";

        package = mkOption {
          type = types.package;
          default = pkgs.htop;
          description = "htop package to install.";
        };

        settings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          example = {
            hide_kernel_threads = 1;
            hide_userland_threads = 1;
            tree_view = 1;
          };
          description = "htop settings as key=value pairs written to ~/.config/htop/htoprc.";
        };
      };

      config = mkIf cfg.enable {
        packages = [ cfg.package ];
        file.".config/htop/htoprc" = mkIf (cfg.settings != { }) {
          text =
            concatStringsSep "\n"
              (mapAttrsToList (key: value: "${key}=${toString value}") cfg.settings)
            + "\n";
        };
      };
    };
in

{
  options.home.users = mkOption {
    type = types.attrsOf (types.submodule htopOpts);
  };
}
