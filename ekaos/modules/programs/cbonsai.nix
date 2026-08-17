# System-wide cbonsai configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cbonsai;
in

{
  options.programs.cbonsai = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cbonsai system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cbonsai;
      description = "cbonsai package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
