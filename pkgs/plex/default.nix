{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "plex-media-server";
  version = "1.41.4.9463-630c9f557";

  src = fetchurl {
    url = "https://downloads.plex.tv/repo/deb/pool/main/p/plexmediaserver/plexmediaserver_${version}_amd64.deb";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    libxml2
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.*
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/lib/plexmediaserver/* $out/
    mkdir -p $out/bin
    makeWrapper $out/Plex\ Media\ Server $out/bin/plexmediaserver \
      --prefix LD_LIBRARY_PATH : "$out"
  '';

  meta = {
    description = "Plex Media Server";
    homepage = "https://plex.tv/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "plexmediaserver";
  };
}
