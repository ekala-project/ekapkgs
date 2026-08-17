# System-wide asm-lsp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.asm-lsp;
in

{
  options.programs.asm-lsp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install asm-lsp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.asm-lsp;
      description = "asm-lsp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
