{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnatpmp";
  version = "20230423";

  src = fetchurl {
    url = "https://miniupnp.tuxfamily.org/files/libnatpmp-${finalAttrs.version}.tar.gz";
    hash = "sha256-BoTtLIQGQ351GaG9IOqDeA24cbOjpddSMRuj6Inb/HA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/miniupnp/libnatpmp/commit/5f4a7c65837a56e62c133db33c28cd1ea71db662.patch";
      hash = "sha256-tvoGFmo5AzUgb40bIs/EzikE0ex1SFzE5peLXhktnbc=";
    })
  ];

  makeFlags = [
    "INSTALLPREFIX=$(out)"
    "CC:=$(CC)"
  ];

  postFixup = ''
    chmod +x $out/lib/*
  '';

  meta = {
    description = "NAT-PMP client";
    homepage = "http://miniupnp.free.fr/libnatpmp.html";
    license = lib.licenses.bsd3;
    mainProgram = "natpmpc";
    platforms = lib.platforms.all;
  };
})
