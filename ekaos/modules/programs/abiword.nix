# System-wide abiword configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.abiword;
in

{
  options.programs.abiword = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install abiword system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.abiword;
      description = "abiword package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
