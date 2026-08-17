# System-wide monolith configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.monolith;
in

{
  options.programs.monolith = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install monolith system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.monolith;
      description = "monolith package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
