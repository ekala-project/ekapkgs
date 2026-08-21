# System-wide rm-improved configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.rm-improved;
in

{
  options.programs.rm-improved = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install rm-improved system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.rm-improved;
      description = "rm-improved package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
