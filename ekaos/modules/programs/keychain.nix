# System-wide keychain configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.keychain;
in

{
  options.programs.keychain = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install keychain system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.keychain;
      description = "keychain package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
