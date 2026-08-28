{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sndio";
  version = "1.10.0";

  src = fetchurl {
    url = "https://www.sndio.org/sndio-${finalAttrs.version}.tar.gz";
    hash = "sha256-vr07/QHFDJN2zz54FLk3m+2eF9A5O1ETt+t6PQ0DjFQ=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isLinux alsa-lib;

  configurePlatforms = [ ];

  postInstall = ''
    install -Dm644 contrib/sndiod.service $out/lib/systemd/system/sndiod.service
  '';

  enableParallelBuilding = true;
  dontDisableStatic = true;

  meta = {
    homepage = "https://www.sndio.org";
    description = "Small audio and MIDI framework part of the OpenBSD project";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
  };
})
