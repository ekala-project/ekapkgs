{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  gtk3,

  cairo,
  ffmpeg,
  gettext,
  glibmm_2_4,
  libmng,
  gtkmm3,
  libjack2,
  libsigcxx_2_0,
  libxmlxx,
  mlt,
  imagemagick,
  intltool,
  adwaita-icon-theme,
  harfbuzz,
  freetype,
  fontconfig,
  fribidi,
  openexr,
  fftw,
}:

let
  version = "1.5.5";
  src = fetchFromGitHub {
    owner = "synfig";
    repo = "synfig";
    rev = "v${version}";
    hash = "sha256-5jVd+YqHVHKkePXBb3zjXEVlgdlU6Yb6LC4CurvsBtE=";
  };

  ETL = stdenv.mkDerivation {
    pname = "ETL";
    inherit version src;

    sourceRoot = "${src.name}/ETL";

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];
  };

  synfig = stdenv.mkDerivation {
    pname = "synfig";
    inherit version src;

    sourceRoot = "${src.name}/synfig-core";

    __structuredAttrs = true;
    strictDeps = true;

    enableParallelBuilding = true;

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
      gettext
      intltool
      imagemagick
    ];

    buildInputs = [
      ETL
      glibmm_2_4
      mlt
      libsigcxx_2_0
      libxmlxx
      imagemagick
      harfbuzz
      freetype
      fontconfig
      fribidi
      openexr
      fftw
      ffmpeg
      libmng
    ];
  };
in
stdenv.mkDerivation {
  pname = "synfigstudio";
  inherit version src;

  sourceRoot = "${src.name}/synfig-studio";

  __structuredAttrs = true;
  strictDeps = true;

  postPatch = ''
    patchShebangs images/splash_screen_development.sh
  '';

  preConfigure = ''
    ./bootstrap.sh
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    intltool
    gtk3.wrapGAppsHook
    synfig
  ];

  buildInputs = [
    ETL
    synfig
    cairo
    glibmm_2_4
    gtk3
    gtkmm3
    imagemagick
    libjack2
    libsigcxx_2_0
    libxmlxx
    mlt
    fontconfig
    ffmpeg
    adwaita-icon-theme
    openexr
    fftw
  ];

  enableParallelBuilding = true;

  passthru = {
    inherit ETL synfig;
  };

  meta = {
    description = "2D animation program";
    homepage = "https://www.synfig.org";
    license = lib.licenses.gpl3Plus;
    mainProgram = "synfigstudio";
    platforms = lib.platforms.linux;
  };
}
