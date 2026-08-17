# System-wide chafa configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.chafa;
in

{
  options.programs.chafa = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install chafa system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.chafa;
      description = "chafa package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
