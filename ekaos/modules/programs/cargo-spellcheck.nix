# System-wide cargo-spellcheck configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-spellcheck;
in

{
  options.programs.cargo-spellcheck = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-spellcheck system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-spellcheck;
      description = "cargo-spellcheck package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
