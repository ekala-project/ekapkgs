# System-wide babeld configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.babeld;
in

{
  options.programs.babeld = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install babeld system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.babeld;
      description = "babeld package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
