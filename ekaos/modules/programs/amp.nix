# System-wide amp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.amp;
in

{
  options.programs.amp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install amp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.amp;
      description = "amp package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
