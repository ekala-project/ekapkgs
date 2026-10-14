# dsearch — fast filesystem search with fuzzy matching
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.dsearch;
in

{
  options.services.dsearch = {
    enable = mkEnableOption "dsearch, a fast filesystem search daemon";

    package = mkOption {
      type = types.package;
      default = pkgs.dsearch;
      description = "dsearch package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.user.services.dsearch = {
      wantedBy = [ "default.target" ];
    };
  };
}
