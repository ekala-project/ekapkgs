# System-wide drill configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.drill;
in

{
  options.programs.drill = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install drill system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.drill;
      description = "drill package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
