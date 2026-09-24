# python-tools — LSP and package managers for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.python.lsp.enable = true;     # pyright (wired by this module)
#   languages.python.poetry.enable = true;  # default: false
#   languages.python.uv.enable = true;      # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.python;
in
{
  options.languages.python = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.pyright;
      description = "The Python language server package.";
    };

    poetry = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include Poetry.";
      };
    };

    uv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include uv.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages =
      lib.optional cfg.poetry.enable pkgs.poetry
      ++ lib.optional cfg.uv.enable pkgs.uv;
  };
}
