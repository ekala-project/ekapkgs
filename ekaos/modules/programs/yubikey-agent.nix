# System-wide yubikey-agent configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.yubikey-agent;
in

{
  options.programs.yubikey-agent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install yubikey-agent system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.yubikey-agent;
      description = "yubikey-agent package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
