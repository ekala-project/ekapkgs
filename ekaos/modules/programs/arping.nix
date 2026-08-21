# System-wide arping configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.arping;
in

{
  options.programs.arping = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install arping system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.arping;
      description = "arping package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
