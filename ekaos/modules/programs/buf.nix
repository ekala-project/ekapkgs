# System-wide buf configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.buf;
in

{
  options.programs.buf = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install buf system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.buf;
      description = "buf package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
