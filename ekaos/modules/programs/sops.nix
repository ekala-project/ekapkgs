# System-wide sops configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.sops;
in

{
  options.programs.sops = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install sops system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.sops;
      description = "sops package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
