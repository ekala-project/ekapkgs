# System-wide aacgain configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aacgain;
in

{
  options.programs.aacgain = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aacgain system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aacgain;
      description = "aacgain package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
