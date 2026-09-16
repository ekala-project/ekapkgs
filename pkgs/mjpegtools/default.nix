{
  stdenv,
  lib,
  fetchurl,
  gtk2,
  libdv,
  libjpeg,
  libpng,
  libx11,
  pkg-config,
  SDL,
  SDL_gfx,
  withMinimal ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mjpegtools";
  version = "2.2.1";

  src = fetchurl {
    url = "mirror://sourceforge/mjpeg/mjpegtools-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-sYBTbX2ZYLBeACOhl7ANyxAJKaSaq3HRnVX0obIQ9Jo=";
  };

  patches = [
    ./c++-17-fixes.patch
    ./remove-subtract-and-union-debug.diff
  ];

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libdv
    libjpeg
    libpng
  ]
  ++ lib.optionals (!withMinimal) [
    gtk2
    libx11
    SDL
    SDL_gfx
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (!withMinimal) "-I${lib.getDev SDL}/include/SDL";

  postPatch = ''
    sed -i -e '/ARCHFLAGS=/s:=.*:=:' configure
  ''
  + lib.optionalString (!(stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian)) ''
    substituteInPlace configure \
      --replace-fail 'have_altivec=true' 'have_altivec=false'
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "lib"
  ];

  meta = {
    description = "Suite of programs for processing MPEG or MJPEG video";
    homepage = "http://mjpeg.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
