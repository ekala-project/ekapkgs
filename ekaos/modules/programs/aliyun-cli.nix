# System-wide aliyun-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.aliyun-cli;
in

{
  options.programs.aliyun-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install aliyun-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.aliyun-cli;
      description = "aliyun-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
