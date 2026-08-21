# System-wide shfmt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.shfmt;
in

{
  options.programs.shfmt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install shfmt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.shfmt;
      description = "shfmt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
