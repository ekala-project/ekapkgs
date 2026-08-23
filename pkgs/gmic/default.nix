{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cimg ? null,
  cmake,
  fftw,
  graphicsmagick ? null,
  libx11,
  libxext,
  libjpeg,
  libpng,
  libtiff,
  llvmPackages ? null,
  ninja,
  opencv ? null,
  openexr ? null,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gmic";
  version = "3.7.6";

  outputs = [
    "out"
    "lib"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "GreycLab";
    repo = "gmic";
    tag = "v.${finalAttrs.version}";
    hash = "sha256-hewDoraw6DCmj1EryZrODFDqzbKI2RhgRuXAop+pg7c=";
  };

  gmic_stdlib = fetchurl {
    name = "gmic_stdlib_community.h";
    url = "https://gmic.eu/gmic_stdlib_community${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.h";
    hash = "sha256-ek8w9uCp4ey5zT8Y1+yM9gXtzigNINOQ0XW6kT6Zj5Q=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    fftw
    libx11
    libxext
    libjpeg
    libpng
    libtiff
    zlib
  ]
  ++ lib.optional (cimg != null) cimg
  ++ lib.optional (graphicsmagick != null) graphicsmagick
  ++ lib.optional (opencv != null) opencv
  ++ lib.optional (openexr != null) openexr
  ++ lib.optionals (stdenv.cc.isClang && llvmPackages != null) [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIB_STATIC" false)
    (lib.cmakeBool "ENABLE_CURL" false)
    (lib.cmakeBool "ENABLE_DYNAMIC_LINKING" true)
    (lib.cmakeBool "ENABLE_OPENCV" (opencv != null))
    (lib.cmakeBool "ENABLE_XSHM" true)
    (lib.cmakeBool "USE_SYSTEM_CIMG" (cimg != null))
  ];

  postPatch = ''
    cp -r ${finalAttrs.gmic_stdlib} src/gmic_stdlib_community.h
  '';

  meta = {
    homepage = "https://gmic.eu/";
    description = "Open and full-featured framework for image processing";
    mainProgram = "gmic";
    license = lib.licenses.cecill21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
