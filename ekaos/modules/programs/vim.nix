# System-wide Vim configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.vim;
in

{
  options.programs.vim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install vim system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.vim;
      description = "Vim package to use.";
    };

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to set vim as the default editor via the EDITOR environment variable.";
    };

    vimrc = mkOption {
      type = types.lines;
      default = "";
      description = ''
        System-wide vimrc configuration written to /etc/vimrc.
        See vim(1) for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.EDITOR = mkIf cfg.defaultEditor "vim";

    environment.etc."vimrc" = mkIf (cfg.vimrc != "") {
      text = cfg.vimrc;
    };
  };
}
