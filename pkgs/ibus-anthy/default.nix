{
  lib,
  stdenv,
  fetchurl,
  gettext,
  pkg-config,
  gtk3,
  anthy,
  ibus,
  glib,
  gobject-introspection,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-anthy";
  version = "1.5.17";

  src = fetchurl {
    url = "https://github.com/ibus/ibus-anthy/releases/download/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-nh0orX2ivl4NnA6w2Pt1V/yJdwqiI3Jy3r4Ze9YavUA=";
  };

  nativeBuildInputs = [
    gettext
    gobject-introspection
    pkg-config
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    anthy
    glib
    gtk3
    ibus
    (python3.withPackages (ps: [
      ps.pygobject3
      (ps.toPythonModule ibus)
    ]))
  ];

  configureFlags = [
    "--with-anthy-zipcode=${anthy}/share/anthy/zipcode.t"
  ];

  postFixup = ''
    substituteInPlace $out/share/ibus/component/anthy.xml --replace \$\{exec_prefix\} $out
  '';

  meta = {
    isIbusEngine = true;
    description = "IBus interface to the anthy input method";
    homepage = "https://github.com/fujiwarat/ibus-anthy";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
