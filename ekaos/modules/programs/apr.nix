# System-wide apr configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apr;
in

{
  options.programs.apr = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apr system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apr;
      description = "apr package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
