{
  lib,
  stdenv,
  fetchFromGitHub,

  withPython ? true,

  cairo,
  cmake,
  ninja,
  curl,
  fcgi,
  freetype,
  fribidi,
  gdal,
  geos,
  giflib,
  harfbuzz,
  libjpeg,
  libpng,
  libpq,
  librsvg,
  libxml2,
  pkg-config,
  proj,
  protobufc,
  python3,
  swig,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mapserver";
  version = "8.6.6";

  src = fetchFromGitHub {
    owner = "MapServer";
    repo = "MapServer";
    rev = "rel-${lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version}";
    hash = "sha256-Mur8yflPhegMxuq10yygT/a0TfFjdV20D4UM4m8Ffpk=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ]
  ++ lib.optionals withPython [
    swig
    python3.pkgs.setuptools
  ];

  buildInputs = [
    cairo
    curl
    fcgi
    freetype
    fribidi
    gdal
    geos
    giflib
    harfbuzz
    libjpeg
    libpng
    libpq
    librsvg
    libxml2
    proj
    protobufc
    zlib
  ]
  ++ lib.optional withPython python3;

  cmakeEntries = {
    WITH_KML = true;
    WITH_SOS = true;
    WITH_RSVG = true;
    WITH_CURL = true;
    WITH_CLIENT_WMS = true;
    WITH_CLIENT_WFS = true;
    WITH_PYTHON = withPython;
    CMAKE_SKIP_BUILD_RPATH = true;
  };

  postInstall = lib.optionalString withPython ''
    mkdir -p $out/${python3.sitePackages}
    cp -r src/mapscript/python/mapscript $out/${python3.sitePackages}
  '';

  meta = {
    description = "Platform for publishing spatial data and interactive mapping applications to the web";
    homepage = "https://mapserver.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
