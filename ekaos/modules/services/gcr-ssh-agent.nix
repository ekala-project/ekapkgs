# GCR SSH Agent — SSH agent backed by GNOME Keyring
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gcr-ssh-agent;
in

{
  options.services.gnome.gcr-ssh-agent = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable GCR SSH agent.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gcr_4;
      description = "GCR package to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      packages = [ cfg.package ];
      user.services.gcr-ssh-agent.wantedBy = [ "default.target" ];
      user.sockets.gcr-ssh-agent.wantedBy = [ "sockets.target" ];
    };
  };
}
