{
  lib,
  stdenv,
  toPythonModule,
  cmake,
  ninja,
  python,
  pythonImportsCheckHook,
  shiboken6,
  shiboken6-generator,
  llvmPackages,
  symlinkJoin,
  packaging,
  setuptools,
  qt6,
}:
let
  packages = [
    # required
    ninja
    packaging
    setuptools
    qt6.qtbase

    # optional
    qt6.qt3d
    qt6.qtcharts
    qt6.qtconnectivity
    qt6.qtdatavis3d
    qt6.qtdeclarative
    qt6.qthttpserver
    qt6.qtmultimedia
    qt6.qtnetworkauth
    qt6.qtquick3d
    qt6.qtremoteobjects
    qt6.qtscxml
    qt6.qtsensors
    qt6.qtspeech
    qt6.qtsvg
    qt6.qtwebchannel
    qt6.qtwebsockets
    qt6.qtwebview
    qt6.qtpositioning
    qt6.qtlocation
    qt6.qtshadertools
    qt6.qtserialport
    qt6.qtserialbus
    qt6.qtgraphs
    qt6.qttools
  ];
  qt_linked = symlinkJoin {
    name = "qt_linked";
    paths = packages;
  };
in

toPythonModule (stdenv.mkDerivation (finalAttrs: {
  pname = "pyside6";

  inherit (shiboken6) version src;

  sourceRoot = "${finalAttrs.src.name}/sources/pyside6";

  # Qt Designer plugin moved to a separate output to reduce closure size
  outputs = [
    "out"
    "devtools"
  ];

  postPatch = ''
    # Don't ignore optional Qt modules
    substituteInPlace cmake/PySideHelpers.cmake \
      --replace-fail \
        'string(FIND "''${_module_dir}" "''${_core_abs_dir}" found_basepath)' \
        'set (found_basepath 0)'
  '';

  # "Couldn't find libclang.dylib"
  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    LLVM_INSTALL_DIR = "${lib.getLib llvmPackages.libclang}/lib";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python
    pythonImportsCheckHook
    shiboken6-generator
  ];

  buildInputs =
    # qtwebengine fails under darwin
    packages ++ [ qt6.qtwebengine ];

  propagatedBuildInputs = [ shiboken6 ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-Dis_pyside6_superproject_build=1"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    chmod +w .
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=pyside6
    cp -r PySide6.egg-info $out/${python.sitePackages}/

    mkdir -p "$devtools"
    moveToOutput "${qt6.qtbase.qtPluginPrefix}/designer" "$devtools"
  '';

  pythonImportsCheck = [ "PySide6" ];

  meta = {
    description = "Python bindings for Qt";
    license = with lib.licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    changelog = "https://code.qt.io/cgit/pyside/pyside-setup.git/tree/doc/changelogs/changes-${finalAttrs.version}?h=v${finalAttrs.version}";
    platforms = lib.platforms.all;
  };
}))
