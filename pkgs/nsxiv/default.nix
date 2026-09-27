{
  lib,
  stdenv,
  fetchFromCodeberg,
  giflib,
  imlib2,
  libxft,
  libexif,
  libwebp,
  conf ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nsxiv";
  version = "34";

  src = fetchFromCodeberg {
    owner = "nsxiv";
    repo = "nsxiv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yv5Px72iZWLtix0K7Tbzhkar7ZBSb121cBzMhkAZhak=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  buildInputs = [
    giflib
    imlib2
    libxft
    libexif
    libwebp
  ];

  postPatch = lib.optionalString (conf != null) ''
    cp ${(builtins.toFile "config.def.h" conf)} config.def.h
  '';

  makeFlags = [ "CC:=$(CC)" ];

  installFlags = [ "PREFIX=$(out)" ];

  installTargets = [ "install-all" ];

  meta = {
    homepage = "https://nsxiv.codeberg.page/";
    description = "New Suckless X Image Viewer";
    mainProgram = "nsxiv";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
