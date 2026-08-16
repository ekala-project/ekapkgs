# System-wide xclip configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.xclip;
in

{
  options.programs.xclip = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install xclip system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.xclip;
      description = "xclip package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
