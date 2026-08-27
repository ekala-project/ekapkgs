# These will be added to the pkgs scope
final: prev: {
  makeDesktopItem = final.lib.makeOverridable (
    import ./build-support/make-desktopitem.nix {
      inherit (final) lib writeTextFile buildPackages;
    }
  );
  copyDesktopItems = final.makeSetupHook {
    name = "copy-desktop-items-hook";
  } ./build-support/copy-desktop-items.sh;
  libmpg123 = final.mpg123;
  docbook_xsl = final.docbook-xsl;
  wafHook = final.waf.hook;
  at-spi2-atk = final.atk;
  at-spi2-core = final.atk;
  wrapGAppsHook3 = final.wrapGAppsNoGuiHook.override {
    isGraphical = true;
  };
  wrapGAppsHook4 = final.wrapGAppsNoGuiHook.override {
    isGraphical = true;
    gtk3 = final.gtk4;
  };
  libxcb-renderutil = final.xcbutilrenderutil;
  libfm-extra = final.libfm.override { extraOnly = true; };
  dconf = prev.dconf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
  gdk-pixbuf = prev.gdk-pixbuf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
  # FFTW precision variants
  fftwSinglePrec = final.fftw.override { precision = "single"; };
  fftwFloat = final.fftwSinglePrec;
  fftwLongDouble = final.fftw.override { precision = "long-double"; };
  # PulseAudio: libpulseaudio is library-only variant
  libpulseaudio = final.pulseaudio.override { libOnly = true; };
  # JACK2: libjack2 is library-only variant
  libjack2 = final.jack2.override { prefix = "lib"; };
  # Legacy alias
  gst_all_1 = final.gstreamer;
  # libpsl.minimal alias (corepkgs curl expects it)
  libpsl = prev.libpsl.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      minimal = prev.libpsl;
    };
  });
  # libsoup v3 alias (libsoup is already v3)
  libsoup_3 = final.libsoup;
  # GSSDP/GUPnP version aliases
  gssdp_1_6 = final.gssdp;
  gupnp_1_6 = final.gupnp;
  # bluez5 alias (bluez is already v5)
  bluez5 = final.bluez;
  # rest/librest version aliases
  rest_1_0 = final.rest; # rest 0.10.x (librest 1.0 API)

  # stub for packages that reference nixosTests
  nixosTests = { };

  # libxcrypt-legacy (all hash algorithms enabled)
  libxcrypt-legacy = final.libxcrypt.override { enableHashes = "all"; };

  # wlroots version alias (wlroots is now 0.20)
  wlroots_0_20 = final.wlroots;

  # evolution-data-server GTK4 variant
  evolution-data-server-gtk4 = final.evolution-data-server.override {
    withGtk3 = false;
    withGtk4 = true;
  };
  gtk4 =
    (prev.gtk4.override {
      trackerSupport = false;
      vulkanSupport = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
      });
  # sdbus-cpp v2 variant
  sdbus-cpp_2 = final.sdbus-cpp.override { version = "2.2.1"; };
  # xwayland with correct dep names
  xwayland = final.callPackage ./pkgs/xwayland {
    libxfont_2 = final.xorg.libXfont2;
    xkeyboard_config = final.xkeyboard-config;
  };
  gtk3 =
    (prev.gtk3.override {
      trackerSupport = false;
      withIntrospection = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
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
