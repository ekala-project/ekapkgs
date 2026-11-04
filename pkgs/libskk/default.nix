{
  lib,
  stdenv,
  fetchFromGitHub,
  libtool,
  gettext,
  pkg-config,
  vala,
  gnome-common,
  gobject-introspection,
  libgee,
  json-glib,
  libxkbcommon,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libskk";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ueno";
    repo = "libskk";
    tag = finalAttrs.version;
    hash = "sha256-Dciz5VeflaX2eYt1B90NpgLKNtCHY/CDabuCx+T/SS0=";
  };

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=int-conversion"
    ];
  };

  buildInputs = [ libxkbcommon ];

  nativeBuildInputs = [
    vala
    gnome-common
    gobject-introspection
    libtool
    gettext
    pkg-config
  ];

  propagatedBuildInputs = [
    libgee
    json-glib
  ];

  configureScript = "./autogen.sh";

  meta = {
    description = "Library to deal with Japanese kana-to-kanji conversion method";
    mainProgram = "skk";
    homepage = "https://github.com/ueno/libskk";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
