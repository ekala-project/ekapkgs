# lua-tools — LSP for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.lua.lsp.enable = true;  # lua-language-server (wired by this module)
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.lua;
in
{
  options.languages.lua = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.lua-language-server;
      description = "The Lua language server package.";
    };
  };
}
