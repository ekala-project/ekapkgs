# System-wide go-swagger configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.go-swagger;
in

{
  options.programs.go-swagger = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install go-swagger system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go-swagger;
      description = "go-swagger package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
