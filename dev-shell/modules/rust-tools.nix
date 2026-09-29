# rust-tools — LSP and companion tools for mkDevShell
#
# Import this module in your mkDevShell modules list, then:
#   languages.rust.lsp.enable = true;      # rust-analyzer (wired by this module)
#   languages.rust.cargo.enable = true;    # default: true
#   languages.rust.clippy.enable = true;   # default: true
#   languages.rust.rustfmt.enable = true;  # default: true
#   languages.rust.lld.enable = true;      # default: false
{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.languages.rust;
in
{
  options.languages.rust = {
    lsp.package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.rust-analyzer;
      description = "The Rust language server package.";
    };

    cargo = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include cargo.";
      };
    };

    clippy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include clippy.";
      };
    };

    rustfmt = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include rustfmt.";
      };
    };

    lld = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use lld as the linker.";
      };
    };
  };

  config = lib.mkIf (cfg.enable or false) {
    environment.packages =
      let
        rustPkgs = cfg.package.pkgs or { };
      in
      lib.optional (cfg.cargo.enable && rustPkgs ? cargo) rustPkgs.cargo
      ++ lib.optional (cfg.clippy.enable && rustPkgs ? clippy) rustPkgs.clippy
      ++ lib.optional (cfg.rustfmt.enable && rustPkgs ? rustfmt) rustPkgs.rustfmt
      ++ lib.optional cfg.lld.enable pkgs.lld;
    environment.variables = lib.mkIf cfg.lld.enable {
      RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
    };
  };
}
