{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  cmake,
  desktop-file-utils,
  intltool,
  llvmPackages,
  libxslt,
  ninja,
  perl,
  pkg-config,
  wrapGAppsHook3,

  # buildInputs
  SDL2,
  adwaita-icon-theme,
  alsa-lib,
  cairo,
  curl,
  exiv2,
  glib,
  glib-networking,
  gmic ? null,
  graphicsmagick,
  gtk3,
  icu,
  isocodes,
  jasper,
  json-glib,
  lcms2,
  lensfun,
  lerc,
  enableAvif ? false,
  libavif ? null,
  libdatrie,
  libepoxy,
  libexif,
  libgcrypt,
  libgpg-error,
  libgphoto2,
  enableHeif ? false,
  libheif ? null,
  libjpeg,
  libpng,
  librsvg,
  libsecret,
  libsysprof-capture,
  libthai,
  libtiff,
  libwebp,
  libxml2,
  lua5_4,
  util-linux,
  openexr,
  openjpeg,
  osm-gps-map ? null,
  pcre2,
  portmidi,
  potrace,
  pugixml,
  sqlite,
  # Linux only
  colord,
  colord-gtk,
  libselinux,
  libsepol,
  libx11,
  libxdmcp,
  libxkbcommon,
  libxtst,
  ocl-icd,
}:
let
  pugixml-shared = pugixml.override { shared = true; };
in
stdenv.mkDerivation rec {
  version = "5.6.0";
  pname = "darktable";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    hash = "sha256-FX1tOEevivyr54lERUeG9zqIbgilBLS9YRTCBl/gBuQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    desktop-file-utils
    intltool
    libxslt # for xsltproc
    llvmPackages.llvm
    ninja
    perl
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    adwaita-icon-theme
    cairo
    curl
    exiv2
    glib
    glib-networking
    graphicsmagick
    gtk3
    icu
    isocodes
    jasper
    json-glib
    lcms2
    lensfun
    lerc
    libdatrie
    libepoxy
    libexif
    libgcrypt
    libgpg-error
    libgphoto2
    libjpeg
    libpng
    librsvg
    libsecret
    libsysprof-capture
    libthai
    libtiff
    libwebp
    libxml2
    lua5_4
    openexr
    openjpeg
    pcre2
    portmidi
    potrace
    pugixml-shared
    sqlite
  ]
  ++ lib.optionals (gmic != null) [ gmic ]
  ++ lib.optionals (osm-gps-map != null) [ osm-gps-map ]
  ++ lib.optionals enableAvif [ libavif ]
  ++ lib.optionals enableHeif [ libheif ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    colord
    colord-gtk
    libselinux
    libsepol
    libx11
    libxdmcp
    libxkbcommon
    libxtst
    ocl-icd
    util-linux
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
    (lib.cmakeBool "USE_GMIC" (gmic != null))
    (lib.cmakeBool "USE_AVIF" enableAvif)
    (lib.cmakeBool "USE_LIBHEIF" enableHeif)
  ];

  # darktable changed its rpath handling and as a result the
  # binaries can't find libdarktable.so, so change LD_LIBRARY_PATH in
  # the wrappers:
  preFixup =
    let
      libPathPrefix =
        "$out/lib/darktable" + lib.optionalString stdenv.hostPlatform.isLinux ":${ocl-icd}/lib";
    in
    ''
      for f in $out/share/darktable/kernels/*.cl; do
        sed -r "s|#include \"(.*)\"|#include \"$out/share/darktable/kernels/\1\"|g" -i "$f"
      done

      gappsWrapperArgs+=(
        --prefix LD_LIBRARY_PATH ":" "${libPathPrefix}"
      )
    '';

  postPatch = ''
    patchShebangs ./tools/generate_styles_string.sh
  '';

  meta = {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = "https://www.darktable.org";
    changelog = "https://github.com/darktable-org/darktable/releases/tag/release-${version}";
    mainProgram = "darktable";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
