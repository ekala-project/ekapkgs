{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  bzip2Support ? true,
  bzip2,
  zlibSupport ? true,
  zlib,
  libX11Support ? !stdenv.hostPlatform.isMinGW,
  libX11,
  libXtSupport ? !stdenv.hostPlatform.isMinGW,
  libXt,
  fontconfigSupport ? true,
  fontconfig,
  freetypeSupport ? true,
  freetype,
  ghostscriptSupport ? false,
  libjpegSupport ? true,
  libjpeg,
  djvulibreSupport ? false,
  lcms2Support ? true,
  lcms2,
  openexrSupport ? !stdenv.hostPlatform.isMinGW,
  openexr,
  libjxlSupport ? false,
  libpngSupport ? true,
  libpng,
  liblqr1Support ? false,
  librsvgSupport ? false,
  libraqmSupport ? false,
  librawSupport ? false,
  libtiffSupport ? true,
  libtiff,
  libxml2Support ? true,
  libxml2,
  openjpegSupport ? !stdenv.hostPlatform.isMinGW,
  openjpeg,
  libwebpSupport ? !stdenv.hostPlatform.isMinGW,
  libwebp,
  libheifSupport ? false,
  libde265Support ? false,
  fftwSupport ? true,
  fftw,
  coreutils,
  curl,
}:

assert libXtSupport -> libX11Support;

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then
      "i686"
    else if
      stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin"
    then
      "x86-64"
    else if
      stdenv.hostPlatform.system == "aarch64-linux" || stdenv.hostPlatform.system == "aarch64-darwin"
    then
      "aarch64"
    else
      null;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "imagemagick";
  version = "7.1.2-30";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick";
    tag = finalAttrs.version;
    hash = "sha256-s2MC/14rNfbuOTI7xVNqr+YN2MobZ/EMnq0hxkJVAj8=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];
  outputMan = "out";

  enableParallelBuilding = true;

  configureFlags = [
    "MVDelegate=${lib.getExe' coreutils "mv"}"
    "RMDelegate=${lib.getExe' coreutils "rm"}"
    "--with-frozenpaths"
    (lib.withFeatureAs (arch != null) "gcc-arch" arch)
    "--without-rsvg"
    "--without-pango"
    "--without-lqr"
    "--without-jxl"
    "--without-uhdr"
    "--without-gslib"
    (lib.withFeature fftwSupport "fftw")
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
  ];

  buildInputs =
    lib.optional zlibSupport zlib
    ++ lib.optional fontconfigSupport fontconfig
    ++ lib.optional libpngSupport libpng
    ++ lib.optional libtiffSupport libtiff
    ++ lib.optional libxml2Support libxml2
    ++ lib.optional openexrSupport openexr
    ++ lib.optional openjpegSupport openjpeg;

  propagatedBuildInputs = [
    curl
  ]
  ++ lib.optional bzip2Support bzip2
  ++ lib.optional freetypeSupport freetype
  ++ lib.optional libjpegSupport libjpeg
  ++ lib.optional lcms2Support lcms2
  ++ lib.optional libX11Support libX11
  ++ lib.optional libXtSupport libXt
  ++ lib.optional libwebpSupport libwebp
  ++ lib.optional fftwSupport fftw;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16HDRI" "$dev"
    configDestination=($out/share/ImageMagick-*)
    grep -v '/nix/store' $dev/lib/ImageMagick-*/config-Q16HDRI/configure.xml > $configDestination/configure.xml
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace-fail "$PKG_CONFIG" \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '$(command -v $PKG_CONFIG)'"
    done
  '';

  meta = {
    homepage = "http://www.imagemagick.org/";
    description = "Software suite to create, edit, compose, or convert bitmap images";
    platforms = lib.platforms.unix;
    maintainers = [ ];
    license = lib.licenses.asl20;
    mainProgram = "magick";
  };
})
