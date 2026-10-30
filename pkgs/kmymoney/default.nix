{
  lib,
  stdenv,
  fetchurl,
  cmake,
  doxygen,
  graphviz,
  pkg-config,
  autoPatchelfHook,
  kdePackages,
  alkimia,
  aqbanking,
  gmp,
  gwenhywfar,
  libical,
  libofx,
  sqlcipher,
  gtk3,
  xvfb-run,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmymoney";
  version = "5.2.2";

  src = fetchurl {
    url = "mirror://kde/stable/kmymoney/${finalAttrs.version}/kmymoney-${finalAttrs.version}.tar.xz";
    hash = "sha256-QLZjnmohYQDSAkjtdPoVQgL5zN+8M1Inztwb746l03c=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    graphviz
    pkg-config
    python3.pkgs.setuptools
    python3.pkgs.wrapPython
    gtk3.wrapGAppsHook
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    kdePackages.kdoctools
    autoPatchelfHook
  ];

  buildInputs = [
    alkimia
    aqbanking
    gmp
    gwenhywfar
    libical
    libofx
    sqlcipher
  ]
  ++ (with kdePackages; [
    akonadi
    karchive
    kcmutils
    kcontacts
    qtwebengine
    kdiagram
    kholidays
    kidentitymanagement
    kitemmodels
    plasma-activities
    qgpgme
  ])
  ++ lib.optional (python3.pkgs ? woob) python3.pkgs.woob;

  patches = [
    ./kmymoney-fix-build-against-qt-6-10.patch
  ];

  postPatch = lib.optionalString (python3.pkgs ? woob) ''
    buildPythonPath "${python3.pkgs.woob}"
    patchPythonScript "kmymoney/plugins/woob/interface/kmymoneywoob.py"

    sed -i -e '1i import sys; sys.argv = [""]' \
      "kmymoney/plugins/woob/interface/kmymoneywoob.py"
  '';

  cmakeEntries = {
    BUILD_WITH_QT6 = true;
  };

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    patchelf --debug --add-needed libpython${python3.pythonVersion}.so \
      "$out/bin/.kmymoney-wrapped"
  '';

  meta = {
    description = "Personal finance manager for KDE";
    mainProgram = "kmymoney";
    homepage = "https://kmymoney.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
