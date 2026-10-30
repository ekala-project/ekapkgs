{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  ffmpeg,
  libid3tag,
  libjpeg,
  libexif,
  sqlite,
  flac,
  libvorbis,
  libogg,
  gettext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "readymedia";
  version = "1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/minidlna/minidlna-${finalAttrs.version}.tar.gz";
    hash = "sha256-OQJsbUoTm5GAGS0cNyJaozdv308adNfeu9u2k9mWr6Q=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gettext
  ];

  buildInputs = [
    ffmpeg
    libid3tag
    libjpeg
    libexif
    sqlite
    flac
    libvorbis
    libogg
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "INSTALLPREFIX=$(out)"
  ];

  meta = {
    description = "Simple DLNA/UPnP media server (formerly known as MiniDLNA)";
    homepage = "https://sourceforge.net/projects/minidlna/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "minidlnad";
  };
})
