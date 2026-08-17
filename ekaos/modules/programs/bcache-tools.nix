# System-wide bcache-tools configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bcache-tools;
in

{
  options.programs.bcache-tools = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bcache-tools system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bcache-tools;
      description = "bcache-tools package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
