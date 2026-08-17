# System-wide amneziawg-tools configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.amneziawg-tools;
in

{
  options.programs.amneziawg-tools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install amneziawg-tools system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.amneziawg-tools;
      description = "amneziawg-tools package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
