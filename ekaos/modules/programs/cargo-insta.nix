# System-wide cargo-insta configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cargo-insta;
in

{
  options.programs.cargo-insta = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cargo-insta system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cargo-insta;
      description = "cargo-insta package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
