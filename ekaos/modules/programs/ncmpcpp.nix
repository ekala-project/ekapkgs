# System-wide ncmpcpp configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ncmpcpp;
in

{
  options.programs.ncmpcpp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ncmpcpp system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ncmpcpp;
      description = "ncmpcpp package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/ncmpcpp/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."ncmpcpp/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
