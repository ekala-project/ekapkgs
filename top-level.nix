# These will be added to the pkgs scope
final: prev: {
  libmpg123 = final.mpg123;
  docbook_xsl = final.docbook-xsl;
  wafHook = final.waf.hook;
  gdk-pixbuf = prev.gdk-pixbuf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
}
