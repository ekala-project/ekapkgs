# These will be added to the pkgs scope
final: prev: {
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
  # Stub for GStreamer until it's properly ported
  gst_all_1 = {
    gstreamer = null;
    gst-plugins-base = null;
    gst-plugins-bad = null;
    gst-plugins-good = null;
    gst-plugins-ugly = null;
  };
  # Stub for tinysparql until tracker is ported
  tinysparql = null;
  gtk4 =
    (prev.gtk4.override {
      trackerSupport = false;
      vulkanSupport = false;
    }).overrideAttrs
      (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
        mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dmedia-gstreamer=disabled" ];
        buildInputs = builtins.filter (x: x != null) old.buildInputs;
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
