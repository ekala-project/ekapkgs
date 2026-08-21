# System-wide password-store configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pass;
in

{
  options.programs.pass = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pass system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pass;
      description = "pass package to use.";
    };

    storeDir = mkOption {
      type = types.str;
      default = "$HOME/.password-store";
      description = "PASSWORD_STORE_DIR path for password-store.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.variables.PASSWORD_STORE_DIR = cfg.storeDir;
  };
}
