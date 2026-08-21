# System-wide Terragrunt configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.terragrunt;
in

{
  options.programs.terragrunt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install terragrunt system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.terragrunt;
      description = "terragrunt package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
