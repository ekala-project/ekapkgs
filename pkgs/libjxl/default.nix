{
  stdenv,
  lib,
  fetchFromGitHub,
  brotli,
  cmake,
  giflib,
  gperftools,
  gtest,
  libhwy,
  libjpeg,
  libpng,
  libwebp,
  gdk-pixbuf,
  openexr,
  pkg-config,
  makeWrapper,
  zlib,
  asciidoc,
  graphviz,
  doxygen,
  python3,
  lcms2,
  enablePlugins ? true,
}:

let
  loadersPath = "${gdk-pixbuf.binaryDir}/jxl-loaders.cache";
in

stdenv.mkDerivation rec {
  pname = "libjxl";
  version = "0.11.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "libjxl";
    repo = "libjxl";
    rev = "v${version}";
    hash = "sha256-ORwhKOp5Nog366UkLbuWpjz/6sJhxUO6+SkoJGH+3fE=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    gdk-pixbuf
    makeWrapper
    asciidoc
    doxygen
    python3
  ];

  depsBuildBuild = [
    graphviz
  ];

  buildInputs = [
    lcms2
    giflib
    gperftools
    gtest
    libjpeg
    libpng
    libwebp
    gdk-pixbuf
    openexr
    zlib
  ];

  propagatedBuildInputs = [
    brotli
    libhwy
  ];

  cmakeFlags = [
    "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON"
    "-DJPEGXL_FORCE_SYSTEM_HWY=ON"
    "-DJPEGXL_FORCE_SYSTEM_GTEST=ON"
    "-DJPEGXL_ENABLE_SKCMS=OFF"
    "-DJPEGXL_FORCE_SYSTEM_LCMS2=ON"
  ]
  ++ lib.optionals enablePlugins [
    "-DJPEGXL_ENABLE_PLUGINS=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isStatic [
    "-DJPEGXL_STATIC=ON"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch32 [
    "-DJPEGXL_FORCE_NEON=ON"
  ];

  postPatch = ''
    shopt -s extglob
    rm -rf third_party/!(sjpeg)/
    shopt -u extglob

    substituteInPlace plugins/gdk-pixbuf/jxl.thumbnailer \
      --replace '/usr/bin/gdk-pixbuf-thumbnailer' "$out/libexec/gdk-pixbuf-thumbnailer-jxl"
    substituteInPlace CMakeLists.txt \
      --replace 'sh$' 'sh( -e$|$)'
  '';

  postInstall =
    lib.optionalString enablePlugins ''
      GDK_PIXBUF_MODULEDIR="$out/${gdk-pixbuf.moduleDir}" \
      GDK_PIXBUF_MODULE_FILE="$out/${loadersPath}" \
        gdk-pixbuf-query-loaders --update-cache
    ''
    + lib.optionalString (enablePlugins && stdenv.hostPlatform == stdenv.buildPlatform) ''
      mkdir -p "$out/bin"
      makeWrapper ${gdk-pixbuf}/bin/gdk-pixbuf-thumbnailer "$out/libexec/gdk-pixbuf-thumbnailer-jxl" \
        --set GDK_PIXBUF_MODULE_FILE "$out/${loadersPath}"
    '';

  CXXFLAGS = lib.optionalString stdenv.hostPlatform.isAarch32 "-mfp16-format=ieee";

  meta = {
    homepage = "https://github.com/libjxl/libjxl";
    description = "JPEG XL image format reference implementation";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
