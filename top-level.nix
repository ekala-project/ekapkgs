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
  # Stub for tinysparql until tracker is ported
  tinysparql = null;
  # Fix lxml: in the python scope, libxml2/libxslt resolve to their -py output,
  # but lxml needs the C development headers (dev output).
  python3 = prev.python3.override {
    packageOverrides = pyFinal: pyPrev: {
      lxml = pyPrev.lxml.overrideAttrs (old: {
        buildInputs = [
          final.libxml2.dev
          final.libxslt.dev
          final.zlib.dev
        ];
      });
    };
  };
  python3Packages = final.python3.pkgs;
  gtk4 =
    (prev.gtk4.override {
      trackerSupport = false;
      vulkanSupport = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
      });
  gtk3 =
    (prev.gtk3.override {
      trackerSupport = false;
      withIntrospection = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
      });
}
