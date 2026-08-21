{
  lib,
  stdenv,
  fetchurl,
  gpm,
  openssl,
  pkg-config,
  libev,
  libpng,
  libjpeg,
  libtiff,
  librsvg,
  bzip2,
  zlib,
  xz,
  libx11,
  libxt,
  libxau,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "links2";
  version = "2.30";

  src = fetchurl {
    url = "https://links.twibright.com/download/links-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xGMca1oRUnzcPLeHL8I7fyslwrAh1Za+QQ2ttAMV8WY=";
  };

  buildInputs = [
    libev
    librsvg
    libpng
    libjpeg
    libtiff
    openssl
    xz
    bzip2
    zlib
    libx11
    libxau
    libxt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gpm
  ];

  nativeBuildInputs = [
    pkg-config
    bzip2
  ];

  configureFlags = [
    "--with-ssl"
    "--enable-graphics"
    "--with-x"
  ];

  meta = {
    homepage = "http://links.twibright.com/";
    description = "Small browser with some graphics support";
    mainProgram = "links";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
