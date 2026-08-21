# System-wide bastet configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bastet;
in

{
  options.programs.bastet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bastet system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bastet;
      description = "bastet package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
