# System-wide massdns configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.massdns;
in

{
  options.programs.massdns = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install massdns system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.massdns;
      description = "massdns package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
