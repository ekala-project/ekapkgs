# System-wide augustus configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.augustus;
in

{
  options.programs.augustus = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install augustus system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.augustus;
      description = "augustus package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
