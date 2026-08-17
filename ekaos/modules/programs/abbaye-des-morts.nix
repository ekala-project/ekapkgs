# System-wide abbaye-des-morts configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.abbaye-des-morts;
in

{
  options.programs.abbaye-des-morts = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install abbaye-des-morts system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.abbaye-des-morts;
      description = "abbaye-des-morts package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
