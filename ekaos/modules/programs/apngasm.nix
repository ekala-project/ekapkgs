# System-wide apngasm configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.apngasm;
in

{
  options.programs.apngasm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install apngasm system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.apngasm;
      description = "apngasm package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
