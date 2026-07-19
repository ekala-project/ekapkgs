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
  version = "2.6.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-2aWhDcmzikOzoPoix27W67fgnrU1r/YpVK/NvUDv/2s=";
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
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
