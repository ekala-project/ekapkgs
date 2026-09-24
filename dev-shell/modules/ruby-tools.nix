# ruby-tools — package manager for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.ruby.bundler.enable = true;  # default: true
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.ruby;
in
{
  options.languages.ruby = {
    bundler = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include bundler.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages = lib.optional cfg.bundler.enable pkgs.bundler;
  };
}
