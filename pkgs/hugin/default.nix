{
  lib,
  stdenv,
  cmake,
  fetchurl,
  make,
  makeWrapper,
  pkg-config,
  gtk3,
  boost,
  cairo,
  enblend-enfuse,
  exiv2,
  fftw,
  flann,
  gettext,
  glew,
  lcms2,
  lensfun,
  libjpeg,
  libpng,
  libtiff,
  libx11,
  libxi,
  libxmu,
  libGLU,
  libGL,
  openexr,
  panotools,
  perlPackages,
  sqlite,
  vigra,
  wxwidgets_3_2,
  wxGTK' ? wxwidgets_3_2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hugin";
  version = "2025.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/hugin/hugin-${finalAttrs.version}.tar.bz2";
    hash = "sha256-fPjrM6aohIzH+Bb69LyIOJIoiD1VExNtzLXLJDkSq3k=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    makeWrapper
    pkg-config
    gtk3.wrapGAppsHook
    wxGTK'
  ];

  buildInputs = [
    boost
    cairo
    exiv2
    fftw
    flann
    gettext
    glew
    lcms2
    lensfun
    libjpeg
    libpng
    libtiff
    libx11
    libxi
    libxmu
    libGLU
    libGL
    openexr
    panotools
    sqlite
    vigra
    wxGTK'
    zlib
  ];

  strictDeps = true;

  # disable installation of the python scripting interface
  cmakeEntries = {
    BUILD_HSI = false;
  };

  # hugin libs are added to NEEDED but not to RUNPATH
  postFixup = ''
    for p in $out/bin/..*; do
      patchelf "$p" --add-rpath $out/lib/hugin
    done
  '';

  postInstall = ''
    for p in $out/bin/*; do
      wrapProgram "$p" \
        --suffix PATH : ${enblend-enfuse}/bin \
        --suffix PATH : ${make}/bin \
        --suffix PATH : ${perlPackages.ImageExifTool}/bin
    done
  '';

  meta = {
    homepage = "https://hugin.sourceforge.io/";
    description = "Toolkit for stitching photographs and assembling panoramas, together with an easy to use graphical front end";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
