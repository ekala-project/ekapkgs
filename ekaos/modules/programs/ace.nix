# System-wide ace configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ace;
in

{
  options.programs.ace = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ace system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ace;
      description = "ace package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
