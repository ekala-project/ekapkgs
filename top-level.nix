# These will be added to the pkgs scope
final: prev: {
  libmpg123 = final.mpg123;
  gdk-pixbuf = prev.gdk-pixbuf.overrideAttrs (old: {
    nativeBuildInputs = old.nativeBuildInputs ++ [ final.meson.configurePhaseHook ];
  });
}
