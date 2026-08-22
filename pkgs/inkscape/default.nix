{
  stdenv,
  lib,
  boehmgc,
  boost,
  cmake,
  fetchpatch,
  fetchurl,
  gettext,
  ghostscript,
  glib,
  glibmm,
  gobject-introspection,
  gsl,
  gspell,
  gtkmm3,
  gtksourceview4,
  gdk-pixbuf,
  graphicsmagick,
  lcms,
  lib2geom,
  libcdr,
  libexif,
  libpng,
  librevenge,
  librsvg,
  libsigcxx,
  libvisio,
  libwpg,
  libxft,
  libxml2,
  libxslt,
  readline,
  ninja,
  perlPackages,
  pkg-config,
  poppler,
  popt,
  potrace,
  python3,
  replaceVars,
  wrapGAppsHook3,
  libepoxy,
  zlib,
}:
let
  python3Env = python3.withPackages (
    ps: with ps; [
      appdirs
      beautifulsoup4
      cssselect
      filelock
      lxml
      numpy
      packaging
      pillow
      pyparsing
      pyserial
      requests
      scour
      tinycss2
      zstandard
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "inkscape";
  version = "1.4.4";
  outputs = [
    "out"
    "man"
  ];

  src = fetchurl {
    url = "https://inkscape.org/release/inkscape-${finalAttrs.version}/source/archive/xz/dl/inkscape-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-u85XU6Hgi4caXPFsZl6wYHAKqrmmo3ncY/TE2bO4hW4=";
  };

  strictDeps = true;

  patches = [
    (replaceVars ./fix-python-paths.patch {
      python3 = lib.getExe python3Env;
    })
    (replaceVars ./fix-ps2pdf-path.patch {
      inherit ghostscript;
    })
  ];

  postPatch = ''
    patchShebangs share/extensions
    patchShebangs share/templates
    patchShebangs man/fix-roff-punct

    substituteInPlace CMakeScripts/DefineDependsandFlags.cmake \
      --replace-fail 'find_package(DoubleConversion REQUIRED)' ""
    shopt -s globstar
    for f in **/CMakeLists.txt; do
      substituteInPlace $f \
        --replace-quiet "COMMAND python3" "COMMAND ${lib.getExe python3Env.pythonOnBuildForHost}"
    done
    shopt -u globstar
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    ninja
    python3Env
    glib
    gdk-pixbuf
    wrapGAppsHook3
    gobject-introspection
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ]);

  buildInputs = [
    boehmgc
    boost
    gettext
    glib
    glibmm
    gsl
    gspell
    gtkmm3
    gtksourceview4
    graphicsmagick
    lcms
    lib2geom
    libcdr
    libexif
    libpng
    librevenge
    librsvg
    libsigcxx
    libvisio
    libwpg
    libxft
    libxml2
    libxslt
    readline
    perlPackages.perl
    poppler
    popt
    potrace
    python3Env
    zlib
    libepoxy
  ];

  meta = {
    description = "Vector graphics editor";
    homepage = "https://www.inkscape.org";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "inkscape";
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit.
    '';
  };
})
