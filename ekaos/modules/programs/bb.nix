# System-wide bb configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bb;
in

{
  options.programs.bb = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bb system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bb;
      description = "bb package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
