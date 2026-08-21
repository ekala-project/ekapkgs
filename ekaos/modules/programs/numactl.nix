# System-wide numactl configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.numactl;
in

{
  options.programs.numactl = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install numactl system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.numactl;
      description = "numactl package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
