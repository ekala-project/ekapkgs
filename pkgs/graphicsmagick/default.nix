{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  nukeReferences,
  bzip2,
  coreutils,
  freetype,
  libx11,
  libjpeg,
  libpng,
  libtiff,
  libtool,
  libwebp,
  libxml2,
  lcms2,
  zlib,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphicsmagick";
  version = "1.3.47";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${finalAttrs.version}.tar.xz";
    hash = "sha256-lftoLasCBqnbFo0GWWP0/99aYLCyo3WsofRJL7GNBic=";
  };

  nativeBuildInputs = [
    nukeReferences
    pkg-config
    xz
  ];

  buildInputs = [
    bzip2
    freetype
    libx11
    libjpeg
    libpng
    libtiff
    libtool
    libwebp
    libxml2
    lcms2
    zlib
  ];

  configureFlags = [
    "MVDelegate=${lib.getExe' coreutils "mv"}"
    (lib.enableFeature true "shared")
    (lib.withFeature true "frozenpaths")
    (lib.withFeatureAs true "quantum-depth" "8")
    "--without-gslib"
  ];

  postConfigure = ''
    nuke-refs -e $out ./magick/magick_config.h
  '';

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  meta = {
    homepage = "http://www.graphicsmagick.org";
    description = "Swiss army knife of image processing";
    license = lib.licenses.mit;
    mainProgram = "gm";
    platforms = lib.platforms.all;
  };
})
