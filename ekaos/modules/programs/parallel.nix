# System-wide parallel configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.parallel;
in

{
  options.programs.parallel = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install parallel system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.parallel;
      description = "parallel package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
