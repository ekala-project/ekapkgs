# System-wide aesfix configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aesfix;
in

{
  options.programs.aesfix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aesfix system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aesfix;
      description = "aesfix package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
