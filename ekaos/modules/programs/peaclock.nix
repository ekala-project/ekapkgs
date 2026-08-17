# System-wide peaclock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.peaclock;
in

{
  options.programs.peaclock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install peaclock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.peaclock;
      description = "peaclock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
