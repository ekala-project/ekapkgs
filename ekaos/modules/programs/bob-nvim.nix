# System-wide bob-nvim configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.bob-nvim;
in

{
  options.programs.bob-nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install bob-nvim system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.bob-nvim;
      description = "bob-nvim package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
