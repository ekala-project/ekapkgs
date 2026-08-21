{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  bzip2,
  zlib,
  libx11,
  libxt,
  fontconfig,
  freetype,
  libjpeg,
  lcms2,
  openexr,
  libpng,
  libtiff,
  libxml2,
  openjpeg,
  libwebp,
  fftw,
  coreutils,
  curl,
}:

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
  version = "7.1.2-24";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick";
    tag = finalAttrs.version;
    hash = "sha256-oSH0dsQ3cuFNYJIIr6LHbv82FbFxxcmkjQ5csTNsYCA=";
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
    "--with-fftw"
  ];

  nativeBuildInputs = [
    pkg-config
    libtool
  ];

  buildInputs = [
    zlib
    fontconfig
    libpng
    libtiff
    libxml2
    openexr
    openjpeg
  ];

  propagatedBuildInputs = [
    curl
    bzip2
    freetype
    libjpeg
    lcms2
    libx11
    libxt
    libwebp
    fftw
  ];

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
