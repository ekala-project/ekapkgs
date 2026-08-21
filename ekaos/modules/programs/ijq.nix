# System-wide ijq configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ijq;
in

{
  options.programs.ijq = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ijq system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ijq;
      description = "ijq package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
