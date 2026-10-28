{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchgit,
  cmake,
  pkg-config,
  ninja,
  flex,
  bison,
  gtk3,
  exiftool,
  python3,
  opencv,
  libtiff,
  libpng,
  libjpeg,
  libheif,
  libjxl,
  boost,
  lcms2,
  expat,
  exiv2,
  libxml2,
  libxslt,
  jasper,
  eigen,
  lensfun,
  liblqr1,
  libgphoto2,
  libusb1,
  imagemagick,
  x265,
  libGLX,
  libGLU,
  kdePackages,
  perl,
  sqlite,
  runtimeShell,
  enblend-enfuse,
  hugin,
  make,
}:

let
  testData = fetchgit {
    url = "https://invent.kde.org/graphics/digikam-test-data.git";
    rev = "d02dd20b23cc279792325a0f03d21688547a7a59";
    fetchLFS = true;
    hash = "sha256-SvsmcniDRorwu9x9OLtHD9ftgquyoE5Kl8qDgqi1XdQ=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "digikam";
  version = "9.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "digikam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rrAqHSG7AsyG8DM0zYfyuGyu6jI/ZDmSYco91nhdmhQ=";
  };

  patches = [
    ./disable-tests-download.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    ninja
    kdePackages.extra-cmake-modules
    flex
    bison
    kdePackages.wrapQtAppsHook
    gtk3.wrapGAppsHook
    python3.pkgs.setuptools
  ];

  buildInputs = [
    opencv.cxxdev
    libtiff
    libpng
    libjpeg
    libheif
    libjxl
    boost
    lcms2
    expat
    exiv2
    libxml2
    libxslt
    jasper
    eigen
    lensfun
    liblqr1
    libgphoto2
    libusb1
    imagemagick
    x265
    libGLX
    libGLU

    kdePackages.qtbase
    kdePackages.qtnetworkauth
    kdePackages.qtscxml
    kdePackages.qtsvg
    kdePackages.qtwayland
    kdePackages.qtwebengine
    kdePackages.qt5compat
    kdePackages.qtmultimedia

    kdePackages.kconfig
    kdePackages.kxmlgui
    kdePackages.ki18n
    kdePackages.kwindowsystem
    kdePackages.kservice
    kdePackages.solid
    kdePackages.kcoreaddons
    kdePackages.knotifyconfig
    kdePackages.knotifications
    kdePackages.threadweaver
    kdePackages.kiconthemes
    kdePackages.kfilemetadata
    kdePackages.kcalendarcore
    kdePackages.kio
    kdePackages.sonnet
  ];

  checkInputs = [ kdePackages.qtdeclarative ];

  postConfigure = lib.optionalString finalAttrs.finalPackage.doCheck ''
    ln -s ${testData} $cmakeDir/test-data
  '';

  postPatch = ''
    substituteInPlace \
      core/dplugins/bqm/custom/userscript/userscript.cpp \
      core/utilities/import/backend/cameracontroller.cpp \
      --replace-fail '"/bin/bash"' ${lib.escapeShellArg "\"${runtimeShell}\""}
  '';

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
    BUILD_TESTING = finalAttrs.finalPackage.doCheck;
    ENABLE_KFILEMETADATASUPPORT = true;
    ENABLE_MEDIAPLAYER = true;
    ENABLE_APPSTYLES = true;
  };

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    qtWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        make
        hugin
        enblend-enfuse
        exiftool
      ]
    })
    qtWrapperArgs+=(--suffix DK_PLUGIN_PATH : $(out)/${kdePackages.qtbase.qtPluginPrefix}/digikam)
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${lib.getExe perl}" \
      --replace "/usr/bin/sqlite3" "${lib.getExe sqlite}"
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Photo management application";
    homepage = "https://www.digikam.org/";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "digikam";
  };
})
