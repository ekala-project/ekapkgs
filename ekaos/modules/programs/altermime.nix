# System-wide altermime configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.altermime;
in

{
  options.programs.altermime = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install altermime system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.altermime;
      description = "altermime package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
