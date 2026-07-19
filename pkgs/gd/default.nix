{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoconf,
  automake,
  pkg-config,
  zlib,
  libpng,
  libjpeg,
  libwebp,
  libtiff,
  libxpm,
  fontconfig,
  freetype,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gd";
  version = "2.3.3";

  src = fetchurl {
    url = "https://github.com/libgd/libgd/releases/download/gd-${finalAttrs.version}/libgd-${finalAttrs.version}.tar.xz";
    sha256 = "0qas3q9xz3wgw06dm2fj0i189rain6n60z1vyq50d5h7wbn25s1z";
  };

  patches = [
    (fetchpatch {
      name = "restore-GD_FLIP.patch";
      url = "https://github.com/libgd/libgd/commit/f4bc1f5c26925548662946ed7cfa473c190a104a.diff";
      sha256 = "XRXR3NOkbEub3Nybaco2duQk0n8vxif5mTl2AUacn9w=";
    })
  ];

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--enable-gd-formats"
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];

  buildInputs = [
    zlib
    freetype
    libpng
    libjpeg
    libwebp
    libtiff
    fontconfig
    libxpm
  ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://libgd.github.io/";
    description = "Dynamic image creation library";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
