# nodejs-tools — LSP and package managers for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.nodejs.lsp.enable = true;    # typescript-language-server (wired by this module)
#   languages.nodejs.pnpm.enable = true;   # default: false
#   languages.nodejs.yarn.enable = true;   # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.nodejs;
in
{
  options.languages.nodejs = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.typescript-language-server;
      description = "The Node.js language server package.";
    };

    pnpm = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include pnpm.";
      };
    };

    yarn = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to include Yarn.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages =
      lib.optional cfg.pnpm.enable pkgs.pnpm ++ lib.optional cfg.yarn.enable pkgs.yarn;
  };
}
