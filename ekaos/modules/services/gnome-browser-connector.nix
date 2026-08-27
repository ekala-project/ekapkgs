# GNOME Browser Connector service
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.gnome.gnome-browser-connector;
in

{
  options.services.gnome.gnome-browser-connector = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable native host connector for the GNOME Shell
        browser extension, a DBus service allowing to install GNOME
        Shell extensions from a web browser.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "chromium/native-messaging-hosts/org.gnome.browser_connector.json".source =
        "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.browser_connector.json";
      "opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json".source =
        "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.browser_connector.json";
      # Legacy paths
      "chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
        "${pkgs.gnome-browser-connector}/etc/chromium/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
      "opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json".source =
        "${pkgs.gnome-browser-connector}/etc/opt/chrome/native-messaging-hosts/org.gnome.chrome_gnome_shell.json";
    };

    environment.systemPackages = [ pkgs.gnome-browser-connector ];

    # TODO: services.dbus.packages = [ pkgs.gnome-browser-connector ];
    # TODO: programs.firefox.nativeMessagingHosts.packages = [ pkgs.gnome-browser-connector ];
  };
}
