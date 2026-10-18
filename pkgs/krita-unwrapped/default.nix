{
  stdenv,
  sdl2-compat,
  boost,
  cmake,
  curl,
  eigen_5,
  exiv2,
  fetchurl,
  fftw,
  fribidi,
  giflib,
  gsl,
  immer,
  kseexpr,
  lager,
  lcms2,
  lib,
  libaom,
  libheif,
  libjxl,
  libmypaint,
  libraw,
  qt6,
  extra-cmake-modules,
  libunibreak,
  libwebp,
  opencolorio,
  openexr,
  openjpeg,
  pkg-config,
  python3Packages,
  xsimd,
  zug,
  breeze-icons,
  karchive,
  kcompletion,
  kconfig,
  kcoreaddons,
  kcrash,
  kguiaddons,
  ki18n,
  kio,
  kitemmodels,
  kitemviews,
  kwidgetsaddons,
  kwindowsystem,
  mlt,
  poppler,
  quazip,
  libkdcraw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "krita-unwrapped";

  version = "6.0.4.1";
  src = fetchurl {
    url = "mirror://kde/stable/krita/${finalAttrs.version}/krita-${finalAttrs.version}.tar.gz";
    hash = "sha256-6v8AUhlYUDqh0+8SBtdeALV+1lmT6VNonwoEhQQn4tg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    python3Packages.sip
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libraw
    fftw
    eigen_5
    exiv2
    fribidi
    lcms2
    gsl
    openexr
    lager
    libaom
    libheif

    giflib
    libjxl
    openjpeg
    opencolorio
    xsimd
    curl
    immer
    kseexpr
    libmypaint
    libunibreak
    libwebp
    sdl2-compat
    zug

    qt6.qtmultimedia
    qt6.qttools

    breeze-icons
    karchive
    kcompletion
    kconfig
    kcoreaddons
    kcrash
    kguiaddons
    ki18n
    kio
    kitemmodels
    kitemviews
    kwidgetsaddons
    kwindowsystem
    mlt
    poppler
    quazip
    libkdcraw
  ];

  # Krita runs custom python scripts in CMake with custom PYTHONPATH which krita determined in their CMake script.
  # Patch the PYTHONPATH so python scripts can import sip successfully.
  postPatch =
    let
      pythonPath = python3Packages.makePythonPath (
        with python3Packages;
        [
          sip
          setuptools
        ]
      );
    in
    ''
      substituteInPlace cmake/modules/FindSIP.cmake \
        --replace 'PYTHONPATH=''${_sip_python_path}' 'PYTHONPATH=${pythonPath}'
      substituteInPlace cmake/modules/SIPMacros.cmake \
        --replace 'PYTHONPATH=''${_krita_python_path}' 'PYTHONPATH=${pythonPath}'

      substituteInPlace plugins/impex/jp2/jp2_converter.cc \
        --replace '<openjpeg.h>' '<${openjpeg.incDir}/openjpeg.h>'
    ''
    # https://invent.kde.org/graphics/krita/-/commit/30182dbfe789c9b44e5762978bf9ebb22c4f72b6
    + ''
      patch -p1 <<EOF
      --- a/cmake/modules/SIPMacros.cmake
      +++ b/cmake/modules/SIPMacros.cmake
      @@ -152,3 +152,3 @@
               if (QT_MAJOR_VERSION STREQUAL "6")
      -            set(abi_version "13.0")
      +            set(abi_version "13.8")
                   set(sip_disabled_features "[\"Krita_Qt5\"]")
      EOF
    '';

  cmakeBuildType = "RelWithDebInfo";

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    ALLOW_UNSTABLE = "QT6";
    ENABLE_UPDATERS = false;
    BUILD_KRITA_QT_DESIGNER_PLUGINS = true;
  };

  meta = {
    description = "Free and open source painting application";
    homepage = "https://krita.org/";
    mainProgram = "krita";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
