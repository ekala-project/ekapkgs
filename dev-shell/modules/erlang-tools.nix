# erlang-tools — LSP for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.erlang.lsp.enable = true;  # erlang-language-platform (wired by this module)
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.erlang;
in
{
  options.languages.erlang = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.erlang-language-platform;
      description = "The Erlang language server package.";
    };
  };
}
