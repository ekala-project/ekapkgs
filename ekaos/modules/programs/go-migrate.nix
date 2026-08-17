# System-wide go-migrate configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.go-migrate;
in

{
  options.programs.go-migrate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install go-migrate system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go-migrate;
      description = "go-migrate package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
