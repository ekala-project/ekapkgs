{
  lib,
  stdenv,
  fetchurl,
  gnum4,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adns";
  version = "1.6.1";

  src = fetchurl {
    urls = [
      "https://www.chiark.greenend.org.uk/~ian/adns/ftp/adns-${finalAttrs.version}.tar.gz"
      "mirror://gnu/adns/adns-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-cTizeJt1Br1oP0UdT32FMHepGAO3s12G7GZ/D5zUAc0=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin.patch ];

  nativeBuildInputs = [
    gnum4
    autoreconfHook
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isStatic "--disable-dynamic";

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.chiark.greenend.org.uk/~ian/adns/";
    description = "Asynchronous DNS resolver library";
    license = [
      lib.licenses.gpl3Plus

      # `adns.h` only
      lib.licenses.lgpl2Plus
    ];
    platforms = lib.platforms.unix;
  };
})
