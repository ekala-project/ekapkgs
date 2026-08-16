# System-wide Newsboat RSS reader configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.newsboat;
in

{
  options.programs.newsboat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install newsboat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.newsboat;
      description = "newsboat package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra newsboat configuration lines written to /etc/newsboat/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."newsboat/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
