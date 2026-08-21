# System-wide antigravity-cli configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.antigravity-cli;
in

{
  options.programs.antigravity-cli = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install antigravity-cli system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.antigravity-cli;
      description = "antigravity-cli package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
