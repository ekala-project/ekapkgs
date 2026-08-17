# System-wide cloc configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.cloc;
in

{
  options.programs.cloc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install cloc system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.cloc;
      description = "cloc package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
