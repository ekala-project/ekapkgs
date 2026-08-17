# System-wide lsd configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.lsd;
in

{
  options.programs.lsd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install lsd system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.lsd;
      description = "lsd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
