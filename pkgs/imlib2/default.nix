{
  lib,
  stdenv,
  fetchurl,
  libjpeg,
  libtiff,
  giflib,
  libpng,
  libwebp,
  libid3tag,
  freetype,
  bzip2,
  pkg-config,
  x11Support ? true,
  webpSupport ? true,
  jxlSupport ? false,
  libjxl ? null,
  libxft,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imlib2";
  version = "1.12.6";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/imlib2-${finalAttrs.version}.tar.xz";
    hash = "sha256-JQ+XUvadxSLlKagaqpOVcF9/wxL/JFPl3lmsK6HyhY8=";
  };

  buildInputs = [
    libjpeg
    libtiff
    giflib
    libpng
    bzip2
    freetype
    libid3tag
    libwebp
  ]
  ++ lib.optionals x11Support [
    libxft
    libxext
  ];

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  configureFlags =
    lib.optional stdenv.hostPlatform.isDarwin "--enable-amd64=no"
    ++ lib.optional (!x11Support) "--without-x";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  meta = {
    description = "Image manipulation library";
    homepage = "https://docs.enlightenment.org/api/imlib2/html";
    license = lib.licenses.imlib2;
    platforms = lib.platforms.unix;
  };
})
