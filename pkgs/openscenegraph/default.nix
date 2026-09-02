{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  cmake,
  pkg-config,
  doxygen,
  libx11,
  libxinerama,
  libxrandr,
  libGLU,
  libGL,
  glib,
  libxml2,
  zlib,
  boost,
  jpegSupport ? true,
  libjpeg,
  exrSupport ? false,
  openexr,
  gifSupport ? true,
  giflib,
  pngSupport ? true,
  libpng,
  tiffSupport ? true,
  libtiff,
  gdalSupport ? false,
  gdal ? null,
  curlSupport ? true,
  curl,
  colladaSupport ? false,
  collada-dom ? null,
  opencascadeSupport ? false,
  opencascade-occt ? null,
  ffmpegSupport ? false,
  ffmpeg,
  nvttSupport ? false,
  nvidia-texture-tools ? null,
  freetypeSupport ? true,
  freetype,
  svgSupport ? false,
  librsvg,
  pdfSupport ? false,
  poppler,
  vncSupport ? false,
  libvncserver ? null,
  lasSupport ? false,
  liblas ? null,
  luaSupport ? false,
  lua,
  sdlSupport ? false,
  SDL2,
  restSupport ? false,
  asio ? null,
  withApps ? false,
  withExamples ? false,
  fltk ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openscenegraph";
  version = "3.6.5";

  src = fetchFromGitHub {
    owner = "openscenegraph";
    repo = "OpenSceneGraph";
    rev = "OpenSceneGraph-${finalAttrs.version}";
    sha256 = "00i14h82qg3xzcyd8p02wrarnmby3aiwmz0z43l50byc9f8i05n1";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    doxygen
  ];

  buildInputs = [
    libx11
    libxinerama
    libxrandr
    libGLU
    libGL
    glib
    libxml2
    zlib
  ]
  ++ lib.optional jpegSupport libjpeg
  ++ lib.optional exrSupport openexr
  ++ lib.optional gifSupport giflib
  ++ lib.optional pngSupport libpng
  ++ lib.optional tiffSupport libtiff
  ++ lib.optional gdalSupport gdal
  ++ lib.optional curlSupport curl
  ++ lib.optionals colladaSupport [
    collada-dom
  ]
  ++ lib.optional opencascadeSupport opencascade-occt
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional nvttSupport nvidia-texture-tools
  ++ lib.optional freetypeSupport freetype
  ++ lib.optional svgSupport librsvg
  ++ lib.optional pdfSupport poppler
  ++ lib.optional vncSupport libvncserver
  ++ lib.optional lasSupport liblas
  ++ lib.optional luaSupport lua
  ++ lib.optional sdlSupport SDL2
  ++ lib.optional restSupport asio
  ++ lib.optionals withExamples [ fltk ]
  ++ lib.optional (restSupport || colladaSupport) boost;

  env = lib.optionalAttrs colladaSupport { COLLADA_DIR = collada-dom; };

  patches = [
    (fetchpatch {
      name = "opencascade-api-patch";
      url = "https://github.com/openscenegraph/OpenSceneGraph/commit/bc2daf9b3239c42d7e51ecd7947d31a92a7dc82b.patch";
      hash = "sha256-VR8YKOV/YihB5eEGZOGaIfJNrig1EPS/PJmpKsK284c=";
    })
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-games/openscenegraph/files/openscenegraph-3.6.5-openexr3.patch?id=0f642d8f09b589166f0e0c0fc84df7673990bf3f";
      hash = "sha256-fdNbkg6Vp7DeDBTe5Zso8qJ5v9uPSXHpQ5XlGkvputk=";
    })
    (fetchurl {
      url = "https://github.com/openscenegraph/OpenSceneGraph/commit/9da8d428f6666427c167b951b03edd21708e1f43.patch";
      hash = "sha256-YGG/DIHU1f6StbeerZoZrNDm348wYB3ydmVIIGTM7fU=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.0 FATAL_ERROR)" \
      "CMAKE_MINIMUM_REQUIRED(VERSION 3.10)"
  '';

  cmakeFlags =
    lib.optional (!withApps) "-DBUILD_OSG_APPLICATIONS=OFF"
    ++ lib.optional withExamples "-DBUILD_OSG_EXAMPLES=ON";

  meta = {
    description = "3D graphics toolkit";
    homepage = "http://www.openscenegraph.org/";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      lgpl21Only
      wxWindowsException31
    ];
  };
})
