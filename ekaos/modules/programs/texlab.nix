# System-wide texlab configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.texlab;
in

{
  options.programs.texlab = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install texlab system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.texlab;
      description = "texlab package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
