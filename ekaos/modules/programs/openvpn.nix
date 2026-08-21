# System-wide openvpn configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.openvpn;
in

{
  options.programs.openvpn = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install openvpn system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.openvpn;
      description = "openvpn package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
