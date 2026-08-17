# System-wide tailspin configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tailspin;
in

{
  options.programs.tailspin = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tailspin system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tailspin;
      description = "tailspin package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
