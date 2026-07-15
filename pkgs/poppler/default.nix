{
  lib,
  stdenv,
  fetchurl,
  cairo,
  cmake,
  boost,
  curl,
  fontconfig,
  freetype,
  glib,
  lcms2,
  util-linux,
  libiconv,
  libintl,
  libjpeg,
  libtiff,
  ninja,
  openjpeg,
  pkg-config,
  python3,
  zlib,
  poppler_data,
  nss,
  expat,
  pcre2,
  xorg,
  libxcb,
  libxml2,
}:

let
  mkFlag = optset: flag: "-DENABLE_${flag}=${if optset then "on" else "off"}";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "poppler-glib";
  version = "25.10.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://poppler.freedesktop.org/poppler-${finalAttrs.version}.tar.xz";
    hash = "sha256-a16btk2rsVeHoU2xZ1KRx6+vk4dDjMk6T7f2rsTub+A=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    python3
    glib
  ];

  buildInputs = [
    boost
    libiconv
    libintl
    poppler_data
    expat
    pcre2
    xorg.libXdmcp
    libxcb
    libxml2
  ];

  propagatedBuildInputs = [
    zlib
    freetype
    fontconfig
    libjpeg
    openjpeg
    cairo
    lcms2
    libtiff
    util-linux
    curl
    nss
  ];

  cmakeFlags = [
    (mkFlag true "UNSTABLE_API_ABI_HEADERS")
    (mkFlag true "GLIB")
    (mkFlag true "CPP")
    (mkFlag true "LIBCURL")
    (mkFlag true "LCMS")
    (mkFlag true "LIBTIFF")
    (mkFlag true "NSS3")
    (mkFlag false "UTILS")
    (mkFlag false "QT5")
    (mkFlag false "QT6")
    (mkFlag false "GPGME")
  ];

  doCheck = false;

  meta = {
    homepage = "https://poppler.freedesktop.org/";
    description = "PDF rendering library";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
