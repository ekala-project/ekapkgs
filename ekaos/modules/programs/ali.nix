# System-wide ali configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ali;
in

{
  options.programs.ali = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ali system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ali;
      description = "ali package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
