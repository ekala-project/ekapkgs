{
  lib,
  stdenv,
  cmake,
  fetchurl,
  gettext,
  gstreamer,
  ninja,
  python3,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcompris";
  version = "26.1";

  src = fetchurl {
    url = "mirror://kde/stable/gcompris/qt/src/gcompris-qt-${finalAttrs.version}.tar.xz";
    hash = "sha256-w4m4Y7KfASzMGz7vdAmC/2x2VME6LjQzl+5GYSTzEzk=";
  };

  postPatch = ''
    # fix concatenation of absolute paths
    substituteInPlace src/core/config.h.in  --replace-fail \
      "../@_data_dest_dir@" "../share/gcompris-qt"
  '';

  cmakeEntries = {
    # QML_BOX2D_LIBRARY = "${kdePackages.qmlbox2d}/${kdePackages.qtbase.qtQmlPrefix}/Box2D.2.1";
    BUILD_TESTING = finalAttrs.finalPackage.doCheck;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    gettext
    ninja
    kdePackages.qttools
    kdePackages.wrapQtAppsHook
    python3.pkgs.setuptools
  ];

  buildInputs =
    (with kdePackages; [
      qtbase
      qtcharts
      qtdeclarative
      qtgraphs
      qtimageformats
      qtmultimedia
      qtsensors
    ])
    ++ [
      gstreamer
      gstreamer.plugins-base
      gstreamer.plugins-good
      gstreamer.plugins-bad
    ];

  postInstall = ''
    install -Dm444 ../org.kde.gcompris.appdata.xml -t $out/share/metainfo

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "High quality educational software suite, including a large number of activities for children aged 2 to 10";
    homepage = "https://gcompris.net/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gcompris-qt";
    platforms = lib.platforms.linux;
  };
})
