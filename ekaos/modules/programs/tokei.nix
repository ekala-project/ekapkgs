# System-wide tokei configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tokei;
in

{
  options.programs.tokei = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tokei system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tokei;
      description = "tokei package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
