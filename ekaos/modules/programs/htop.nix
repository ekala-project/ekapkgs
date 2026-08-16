# System-wide htop configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.htop;
in

{
  options.programs.htop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install htop system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.htop;
      description = "htop package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = {
        hide_kernel_threads = 1;
        hide_userland_threads = 1;
        tree_view = 1;
      };
      description = ''
        System-wide htop settings written to /etc/htoprc.
        See htop(1) for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."htoprc" = mkIf (cfg.settings != { }) {
      text = concatStringsSep "\n" (
        mapAttrsToList (key: value: "${key}=${toString value}") cfg.settings
      ) + "\n";
    };
  };
}
