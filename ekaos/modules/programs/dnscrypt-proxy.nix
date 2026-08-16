# System-wide dnscrypt-proxy configuration
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.programs.dnscrypt-proxy;
  tomlFormat = pkgs.formats.toml { };
  settingsFile = tomlFormat.generate "dnscrypt-proxy.toml" cfg.settings;
in

{
  options.programs.dnscrypt-proxy = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to install dnscrypt-proxy system-wide.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dnscrypt-proxy;
      description = "dnscrypt-proxy package to use.";
    };

    settings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      description = "dnscrypt-proxy TOML configuration settings.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."dnscrypt-proxy/dnscrypt-proxy.toml" = mkIf (cfg.settings != { }) {
      source = settingsFile;
    };
  };
}
