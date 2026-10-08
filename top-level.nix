# These will be added to the pkgs scope
final: prev: {
  jre = final.java;
  qt5Packages = final.qt5;
  libsForQt5 = final.qt5;
  docbook_xsl = final.docbook-xsl;
  libxcb-renderutil = final.xcbutilrenderutil;
  libfm-extra = final.libfm.override { extraOnly = true; };
  # openal is an alias for openal-soft
  openal = final.openal-soft;

  # Rust infrastructure aliases
  rustPlatform = final.rust.packages.stable.rustPlatform;

  # dnsutils is just the utils output of bind
  dnsutils = final.bind.utils;

  # vte-gtk4 is the GTK4 variant of vte
  vte-gtk4 = final.vte.override {
    gtkVersion = "4";
    gtk4 = final.gtk4;
  };

  # colord-gtk4 is colord-gtk built with GTK4
  colord-gtk4 = final.colord-gtk.override { withGtk4 = true; };

  # nixos-icons is a simple data package
  nixos-icons = final.callPackage ./pkgs/nixos-icons { };

  # libcanberra-gtk3 alias for the gtk3 variant from pkgs-many
  libcanberra-gtk3 = final.libcanberra.gtk3;

  # WebKit GTK: base variant is GTK4 (ABI 6.0)
  webkitgtk_6_0 = final.webkitgtk;

  # libnma-gtk4 variant
  libnma-gtk4 = final.libnma.override {
    withGtk4 = true;
    gtk4 = final.gtk4;
  };

  # libsoup_2_4 has been removed upstream; stub it out
  libsoup_2_4 = null;

  # Discord variant aliases
  discord-ptb = final.discord.ptb;
  discord-canary = final.discord.canary;
  discord-development = final.discord.development;

  # stub for packages that reference nixosTests
  nixosTests = { };

  # Break qt6 <-> doxygen cycle: doxygen optionally depends on qt6,
  # but qt6.qtbase transitively depends on doxygen through libxml2.
  doxygen = prev.doxygen.override { qt6 = null; };

  # Qt convenience aliases
  qt6Packages = final.qt6;

  # libxcrypt-legacy (all hash algorithms enabled)
  libxcrypt-legacy = final.libxcrypt.override { enableHashes = "all"; };

  # evolution-data-server GTK4 variant
  evolution-data-server-gtk4 = final.evolution-data-server.override {
    withGtk3 = false;
    withGtk4 = true;
  };
  # sdbus-cpp v2 variant
  sdbus-cpp_2 = final.sdbus-cpp.override { version = "2.2.1"; };

  # Fix opencascade-occt: add missing libX11 headers
  # The corepkgs build has Xlib detection (HAVE_XLIB) but cmake doesn't find X11
  # include directories. Add libx11 and pass 3RDPARTY_INCLUDE_DIRS so cmake can
  # locate X11/Xlib.h.
  opencascade-occt = prev.opencascade-occt.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [
      final.libx11
      final.fontconfig
    ];
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_CXX_FLAGS=-isystem ${final.libx11.dev}/include -isystem ${final.xorgproto.include}/include -isystem ${final.fontconfig.dev}/include -isystem ${final.libGL.dev}/include"
      "-DCMAKE_C_FLAGS=-isystem ${final.libx11.dev}/include -isystem ${final.xorgproto.include}/include -isystem ${final.fontconfig.dev}/include -isystem ${final.libGL.dev}/include"
    ];
  });

  # GNOME Shell extensions convenience set
  gnomeExtensions = {
    appindicator = final.gnome-shell-extension-appindicator;
    dash-to-panel = final.gnome-shell-extension-dash-to-panel;
    caffeine = final.gnome-shell-extension-caffeine;
    gsconnect = final.gnome-shell-extension-gsconnect;
    blur-my-shell = final.gnome-shell-extension-blur-my-shell;
    dash-to-dock = final.gnome-shell-extension-dash-to-dock;
    no-overview = final.gnome-shell-extension-no-overview;
    just-perfection = final.gnome-shell-extension-just-perfection;
    pop-shell = final.gnome-shell-extension-pop-shell;
    vertical-workspaces = final.gnome-shell-extension-vertical-workspaces;
    paperwm = final.gnome-shell-extension-paperwm;
    clipboard-indicator = final.gnome-shell-extension-clipboard-indicator;
    kimpanel = final.gnome-shell-extension-kimpanel;
    freon = final.gnome-shell-extension-freon;
  };
}
