{
  lib,
  boost,
  bzip2,
  cmake,
  enablePython ? true,
  fetchFromGitHub,
  fmt,
  giflib,
  libjpeg,
  libjxl,
  libpng,
  libtiff,
  libwebp,
  opencolorio,
  openexr,
  openjph,
  ptex,
  python3,
  python3Packages,
  robin-map,
  stdenv,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openimageio";
  version = "3.1.16.0";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "OpenImageIO";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6oeJHdMToAqPJs4po6QbKCu4Xqbi5nawNXT35Eckv2Q=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    unzip
  ];

  buildInputs = [
    boost
    bzip2
    giflib
    libjpeg
    libjxl
    libpng
    libtiff
    libwebp
    opencolorio
    openexr
    openjph
    ptex
    robin-map
  ]
  ++ lib.optionals enablePython [
    python3
    python3Packages.pybind11
  ];

  propagatedBuildInputs = [
    fmt
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_PYTHON" enablePython)
    "-DUSE_QT=OFF"
    # GNUInstallDirs
    "-DCMAKE_INSTALL_LIBDIR=lib" # needs relative path for pkg-config
    # Do not install a copy of fmt header files
    "-DINTERNALIZE_FMT=OFF"
    # libultrahdr and libheif are not available
    "-DUSE_LIBUHDR=OFF"
    "-DUSE_HEIF=OFF"
  ]
  ++ lib.optionals enablePython [
    (lib.cmakeFeature "Python3_ROOT" "${python3}")
    (lib.cmakeFeature "Python3_FIND_STRATEGY" "LOCATION")
  ];

  postFixup = ''
    substituteInPlace $dev/lib/cmake/OpenImageIO/OpenImageIOTargets-*.cmake \
      --replace "\''${_IMPORT_PREFIX}/lib/lib" "$out/lib/lib"
  '';

  meta = {
    homepage = "https://openimageio.org";
    description = "Library and tools for reading and writing images";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
