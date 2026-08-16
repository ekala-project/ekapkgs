# System-wide delta configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.delta;
  gitconfigText =
    concatStringsSep "\n" (
      [ "[delta]" ] ++ mapAttrsToList (key: value: "\t${key} = ${toString value}") cfg.settings
    )
    + "\n";
in

{
  options.programs.delta = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install delta system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.delta;
      description = "delta package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = {
        line-numbers = true;
        side-by-side = true;
      };
      description = ''
        Delta settings written to /etc/delta.gitconfig in gitconfig format.
        Users should set programs.git.config.core.pager = "delta" and
        programs.git.config.interactive.diffFilter = "delta --color-only"
        separately, and include this file via
        programs.git.config.include.path = "/etc/delta.gitconfig".
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."delta.gitconfig" = mkIf (cfg.settings != { }) {
      text = gitconfigText;
    };
  };
}
