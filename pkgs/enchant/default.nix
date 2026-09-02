{
  lib,
  stdenv,
  fetchurl,
  aspell,
  groff,
  pkg-config,
  glib,
  hunspell,
}:

stdenv.mkDerivation rec {
  pname = "enchant";
  version = "2.8.19";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-yNcJkdVE7jknS5a9AdKFigCf5zL/Q/Kq9gX9YezQb2A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    groff
    pkg-config
  ];

  buildInputs = [
    glib
    hunspell
  ];

  propagatedBuildInputs = [
    aspell
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-relocatable"
    "--with-aspell"
    "--without-hspell"
    "--with-hunspell"
    "--without-nuspell"
    "--without-voikko"
    "--without-applespell"
  ];

  meta = {
    description = "Generic spell checking library";
    homepage = "https://rrthomas.github.io/enchant/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
