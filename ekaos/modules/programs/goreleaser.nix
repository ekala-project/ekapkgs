# System-wide goreleaser configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.goreleaser;
in

{
  options.programs.goreleaser = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install goreleaser system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.goreleaser;
      description = "goreleaser package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
