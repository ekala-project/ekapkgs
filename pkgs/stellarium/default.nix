{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  perl,
  gtk3,
  qt6,
  qt6Packages ? { },
  calcmysky ? null,
  indilib,
  libnova,
  exiv2,
  nlopt,
  python3,
  md4c,
  withQtWebEngine ? lib.meta.availableOn stdenv.hostPlatform qt6.qtwebengine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellarium";
  version = "26.3";

  src = fetchFromGitHub {
    owner = "Stellarium";
    repo = "stellarium";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eEq5ubQLF2VaukpLG0pHSbIudChZwEIUdRteeY7VbpI=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/stellarium/-/raw/ab559b6e9349569278f83c2dfc83990e971a8cb2/qt-6.10.patch";
      hash = "sha256-a7zC9IQOj93VnPy8Bj/fLe4oJux7I4Edgj5OaKI4TZU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    perl
    python3.pkgs.setuptools
    gtk3.wrapGAppsHook
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qtpositioning
    qt6.qtmultimedia
    qt6.qtserialport
    indilib
    libnova
    exiv2
    md4c
    nlopt
  ]
  ++ lib.optionals (qt6Packages ? qxlsx) [ qt6Packages.qxlsx ]
  ++ lib.optionals (calcmysky != null) [
    calcmysky
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6.qtwayland
  ]
  ++ lib.optionals withQtWebEngine [
    qt6.qtwebengine
  ];

  preConfigure = ''
    export SOURCE_DATE_EPOCH=$(date -d 20${lib.versions.major finalAttrs.version}0101 +%s)
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Free open-source planetarium";
    mainProgram = "stellarium";
    homepage = "https://stellarium.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
