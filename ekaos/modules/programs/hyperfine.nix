# System-wide hyperfine configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.hyperfine;
in

{
  options.programs.hyperfine = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install hyperfine system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.hyperfine;
      description = "hyperfine package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
