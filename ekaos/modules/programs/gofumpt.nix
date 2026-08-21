# System-wide gofumpt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.gofumpt;
in

{
  options.programs.gofumpt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install gofumpt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gofumpt;
      description = "gofumpt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
