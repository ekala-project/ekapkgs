# System-wide _1password-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_1password-cli";
in

{
  options.programs."_1password-cli" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _1password-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._1password-cli;
      description = "_1password-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
