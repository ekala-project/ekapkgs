# System-wide _0xffff configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs."_0xffff";
in

{
  options.programs."_0xffff" = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install _0xffff system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs._0xffff;
      description = "_0xffff package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
