# System-wide stylua configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.stylua;
in

{
  options.programs.stylua = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install stylua system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.stylua;
      description = "stylua package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
