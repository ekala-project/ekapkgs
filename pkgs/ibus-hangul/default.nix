{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  appstream-glib,
  gettext,
  pkg-config,
  gtk3,
  gobject-introspection,
  autoreconfHook,
  ibus,
  libhangul,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ibus-hangul";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "libhangul";
    repo = "ibus-hangul";
    tag = finalAttrs.version;
    hash = "sha256-x2oOW8eiEuwmdCGUo+r/KcsitfGccSyianwIEaOBS3M=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      libhangul = "${libhangul}/lib/libhangul.so.1";
    })
  ];

  nativeBuildInputs = [
    appstream-glib
    gettext
    pkg-config
    gtk3.wrapGAppsHook
    gobject-introspection.setupHook
    autoreconfHook
  ];

  buildInputs = [
    gtk3
    ibus
    libhangul
    (python3.withPackages (
      pypkgs: with pypkgs; [
        pygobject3
        (toPythonModule ibus)
      ]
    ))
  ];

  meta = {
    isIbusEngine = true;
    description = "Ibus Hangul engine";
    mainProgram = "ibus-setup-hangul";
    homepage = "https://github.com/libhangul/ibus-hangul";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
