# System-wide tofi configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.tofi;
in

{
  options.programs.tofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install tofi system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.tofi;
      description = "tofi package to use.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra configuration written to /etc/tofi/config.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."tofi/config" = mkIf (cfg.extraConfig != "") {
      text = cfg.extraConfig;
    };
  };
}
