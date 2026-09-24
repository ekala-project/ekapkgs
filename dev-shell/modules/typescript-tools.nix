# typescript-tools — LSP and package managers for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.typescript.lsp.enable = true;    # typescript-language-server (wired by this module)
#   languages.typescript.pnpm.enable = true;   # default: false
#   languages.typescript.yarn.enable = true;   # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.typescript;
in
{
  options.languages.typescript = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.typescript-language-server;
      description = "The TypeScript language server package.";
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
