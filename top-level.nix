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
  libfm-extra = final.libfm.override { extraOnly = true; };
  dconf = prev.dconf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
  gdk-pixbuf = prev.gdk-pixbuf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
  gtk3 = (prev.gtk3.override {
    trackerSupport = false;
    withIntrospection = false;
  }).overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
}
