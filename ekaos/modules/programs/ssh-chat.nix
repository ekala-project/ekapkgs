# System-wide ssh-chat configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.ssh-chat;
in

{
  options.programs.ssh-chat = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install ssh-chat system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ssh-chat;
      description = "ssh-chat package to use.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
