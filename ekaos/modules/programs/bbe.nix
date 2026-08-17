# System-wide bbe configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bbe;
in

{
  options.programs.bbe = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bbe system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bbe;
      description = "bbe package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
