# System-wide mle configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.mle;
in

{
  options.programs.mle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install mle system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.mle;
      description = "mle package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
