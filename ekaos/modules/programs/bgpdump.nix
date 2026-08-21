# System-wide bgpdump configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bgpdump;
in

{
  options.programs.bgpdump = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bgpdump system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bgpdump;
      description = "bgpdump package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
