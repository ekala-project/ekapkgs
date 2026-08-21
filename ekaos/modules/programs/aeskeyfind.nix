# System-wide aeskeyfind configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aeskeyfind;
in

{
  options.programs.aeskeyfind = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aeskeyfind system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aeskeyfind;
      description = "aeskeyfind package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
