{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  cacert,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libressl";
  version = "4.2.1";

  src = fetchurl {
    url = "mirror://openbsd/LibreSSL/libressl-${finalAttrs.version}.tar.gz";
    hash = "sha256-bVwvWFg1iOp5H0yGRQBAcdAN+lVKW/eIoAbKHrWr1ws=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DENABLE_NC=ON"
    "-DCMAKE_C_FLAGS=-DHAVE_GNU_STACK"
    "-DTLS_DEFAULT_CA_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/libressl/portable/commit/a15ea0710398eaeed3be53cf643e80a1e80c981d.patch";
      hash = "sha256-Mlf4SrGCCqALQicbGtmVGdkdfcE8DEGYkOuVyG2CozM=";
    })
  ];

  preConfigure = ''
    rm configure
  '';

  postPatch = ''
    patchShebangs tests/
  '';

  strictDeps = true;

  doCheck = false;

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "nc"
  ];

  postFixup = ''
    moveToOutput "bin/nc" "$nc"
    moveToOutput "bin/openssl" "$bin"
    moveToOutput "bin/ocspcheck" "$bin"
    moveToOutput "share/man/man1/nc.1.gz" "$nc"
  '';

  meta = {
    description = "Free TLS/SSL implementation";
    homepage = "https://www.libressl.org";
    license = with lib.licenses; [
      publicDomain
      bsdOriginal
      bsd0
      bsd3
      gpl3
      isc
      openssl
    ];
    platforms = lib.platforms.all;
  };
})
