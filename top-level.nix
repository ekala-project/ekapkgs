# These will be added to the pkgs scope
final: prev: {
  makeDesktopItem = final.lib.makeOverridable (
    import ./build-support/make-desktopitem.nix {
      inherit (final) lib writeTextFile buildPackages;
    }
  );
  jre = final.jdk;
  libmpg123 = final.mpg123;
  libdbusmenu-gtk3 = final.libdbusmenu.override { withGtk3 = true; };
  docbook_xsl = final.docbook-xsl;
  wafHook = final.waf.hook;
  wrapGAppsHook3 = final.wrapGAppsNoGuiHook.override {
    isGraphical = true;
  };
  wrapGAppsHook4 = final.wrapGAppsNoGuiHook.override {
    isGraphical = true;
    gtk3 = final.gtk4;
  };
  libxcb-renderutil = final.xcbutilrenderutil;
  libfm-extra = final.libfm.override { extraOnly = true; };
  fftwFloat = final.fftwSinglePrec;
  # PulseAudio: libpulseaudio is library-only variant
  libpulseaudio = final.pulseaudio.override { libOnly = true; };
  # JACK2: libjack2 is library-only variant
  libjack2 = final.jack2.override { prefix = "lib"; };
  # GSSDP/GUPnP version aliases
  gssdp_1_6 = final.gssdp;
  gupnp_1_6 = final.gupnp;
  # openal is an alias for openal-soft
  openal = final.openal-soft;

  # Rust infrastructure aliases
  rustPlatform = final.rust.packages.stable.rustPlatform;
  cargo = final.rust.packages.stable.cargo;
  clippy = final.rust.packages.stable.clippy;
  rustfmt = final.rust.packages.stable.rustfmt;
  rustc = final.rust.packages.stable.rustc;
  # bluez5 alias (bluez is already v5)
  bluez5 = final.bluez;
  # rest/librest version aliases
  rest_1_0 = final.rest; # rest 0.10.x (librest 1.0 API)

  # Fix zeromq: disable doc generation (asciidoc binary not available)
  # TODO: remove once corepkgs zeromq fix is upstream
  zeromq = prev.zeromq.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DWITH_DOC=OFF" ];
    postBuild = "";
    postInstall = "";
  });

  # GStreamer: map gst_all_1 to the gstreamer scope (corepkgs stubs them as null)
  gst_all_1 = {
    inherit (final.gstreamer)
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      gst-libav
      gst-rtsp-server
      gst-devtools
      ;
    # TODO: port these remaining GStreamer components
    gst-editing-services = null;
    gst-plugins-rs = null;
    gstreamermm = null;
  };

  # stub for packages that reference nixosTests
  nixosTests = { };

  # libxcrypt-legacy (all hash algorithms enabled)
  libxcrypt-legacy = final.libxcrypt.override { enableHashes = "all"; };

  # wlroots version aliases (wlroots is now 0.20, older versions removed)
  wlroots_0_18 = null;
  wlroots_0_19 = null;
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
