# System-wide bar configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bar;
in

{
  options.programs.bar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bar system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bar;
      description = "bar package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
