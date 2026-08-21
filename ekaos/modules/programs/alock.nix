# System-wide alock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.alock;
in

{
  options.programs.alock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install alock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.alock;
      description = "alock package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
