# keyd — key remapping daemon
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.keyd;
in

{
  options.programs.keyd = {
    enable = mkEnableOption "keyd, a key remapping daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.keyd;
      description = "keyd package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.keyd = {
      wantedBy = [ "multi-user.target" ];
    };
  };
}
