# System-wide pdfgrep configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pdfgrep;
in

{
  options.programs.pdfgrep = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pdfgrep system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pdfgrep;
      description = "pdfgrep package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
