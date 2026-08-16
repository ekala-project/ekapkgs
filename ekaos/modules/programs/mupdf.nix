# System-wide mupdf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mupdf;
in

{
  options.programs.mupdf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mupdf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mupdf;
      description = "mupdf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
