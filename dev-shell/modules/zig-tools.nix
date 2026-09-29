# zig-tools — LSP for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.zig.lsp.enable = true;  # zls (wired by this module)
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.zig;
in
{
  options.languages.zig = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.zls;
      description = "The Zig language server package.";
    };
  };
}
