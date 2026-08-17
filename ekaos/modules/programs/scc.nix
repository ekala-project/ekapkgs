# System-wide scc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.scc;
in

{
  options.programs.scc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install scc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.scc;
      description = "scc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
