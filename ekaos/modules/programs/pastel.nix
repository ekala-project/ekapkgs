# System-wide pastel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.pastel;
in

{
  options.programs.pastel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install pastel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.pastel;
      description = "pastel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
