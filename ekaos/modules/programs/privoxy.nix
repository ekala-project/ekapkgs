# System-wide privoxy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.privoxy;
in

{
  options.programs.privoxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install privoxy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.privoxy;
      description = "privoxy package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional privoxy configuration content.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."privoxy/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
