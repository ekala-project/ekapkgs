# System-wide bchunk configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bchunk;
in

{
  options.programs.bchunk = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bchunk system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bchunk;
      description = "bchunk package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
