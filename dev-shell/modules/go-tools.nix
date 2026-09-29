# go-tools — LSP for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.go.lsp.enable = true;  # gopls (wired by this module)
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.go;
in
{
  options.languages.go = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.gopls;
      description = "The Go language server package.";
    };
  };
}
