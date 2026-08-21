# System-wide swaylock configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.swaylock;
in

{
  options.programs.swaylock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install swaylock system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.swaylock;
      description = "swaylock package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra swaylock configuration content written to /etc/swaylock/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."swaylock/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
