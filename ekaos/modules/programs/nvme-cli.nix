# System-wide nvme-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.nvme-cli;
in

{
  options.programs.nvme-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install nvme-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nvme-cli;
      description = "nvme-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
