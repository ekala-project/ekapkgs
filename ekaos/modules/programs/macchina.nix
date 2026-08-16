# System-wide macchina configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.macchina;
in

{
  options.programs.macchina = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install macchina system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.macchina;
      description = "macchina package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
