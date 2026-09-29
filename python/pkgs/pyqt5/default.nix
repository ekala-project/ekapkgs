{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  pkg-config,
  dbus,
  lndir,
  dbus-python,
  sip,
  pyqt5-sip,
  pyqt-builder,
  qt5,
  enableVerbose ? true,
  withConnectivity ? false,
  withMultimedia ? false,
  withWebSockets ? false,
  withLocation ? false,
  withSerialPort ? false,
  withTools ? false,
  dbusSupport ? true,
}:

let
  # sip 6.16+ defaults to ABI v13 and its _finalise_abi_version rejects
  # ABI v12 when minimum_abi_versions is empty. PyQt5 requires ABI v12.
  # Pin sip to 6.15.1 which defaults to ABI v12.
  sip_6_15 = sip.overridePythonAttrs (old: rec {
    version = "6.15.1";
    src = fetchPypi {
      pname = "sip";
      inherit version;
      hash = "sha256-3C5YwXmKdOGzHCjoNzOYIv6PpVKIrjDomG6ygQDrylo=";
    };
  });
in
buildPythonPackage rec {
  pname = "pyqt5";
  version = "5.15.10";
  pyproject = true;

  src = fetchPypi {
    pname = "PyQt5";
    inherit version;
    hash = "sha256-1Gt4BLGxCk/5F1P4ET5bVYDStEYvMiYoji2ESXM0iYo=";
  };

  patches = [
    ./pyqt5-fix-dbus-mainloop-support.patch
    ./pyqt5-confirm-license.patch
  ];

  postPatch = ''
    cat >> pyproject.toml <<EOF
  ''
  + lib.optionalString enableVerbose ''
    [tool.sip.project]
    verbose = true
  ''
  + ''
    EOF
  '';

  enableParallelBuilding = true;
  postUnpack = ''
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '';

  env = lib.optionalAttrs (!enableVerbose) { NIX_CFLAGS_COMPILE = "-w"; };

  outputs = [
    "out"
    "dev"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    qt5.qmake
    setuptools
    lndir
    sip_6_15
    qt5.qtbase
    qt5.qtsvg
    qt5.qtdeclarative
  ]
  ++ lib.optional withConnectivity qt5.qtconnectivity
  ++ lib.optional withMultimedia qt5.qtmultimedia
  ++ lib.optional withWebSockets qt5.qtwebsockets
  ++ lib.optional withLocation qt5.qtlocation
  ++ lib.optional withSerialPort qt5.qtserialport
  ++ lib.optional withTools qt5.qttools;

  buildInputs = [
    dbus
    qt5.qtbase
    qt5.qtsvg
    qt5.qtdeclarative
    pyqt-builder
  ]
  ++ lib.optional withConnectivity qt5.qtconnectivity
  ++ lib.optional withWebSockets qt5.qtwebsockets
  ++ lib.optional withLocation qt5.qtlocation
  ++ lib.optional withSerialPort qt5.qtserialport
  ++ lib.optional withTools qt5.qttools;

  propagatedBuildInputs = [
    dbus-python
    pyqt5-sip
  ];

  passthru = {
    sip = sip_6_15;
    inherit pyqt5-sip;
    multimediaEnabled = withMultimedia;
    WebSocketsEnabled = withWebSockets;
    connectivityEnabled = withConnectivity;
    locationEnabled = withLocation;
    serialPortEnabled = withSerialPort;
    toolsEnabled = withTools;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [
    "PyQt5"
    "PyQt5.QtCore"
    "PyQt5.QtQml"
    "PyQt5.QtWidgets"
    "PyQt5.QtGui"
  ]
  ++ lib.optional withWebSockets "PyQt5.QtWebSockets"
  ++ lib.optional withMultimedia "PyQt5.QtMultimedia"
  ++ lib.optional withConnectivity "PyQt5.QtBluetooth"
  ++ lib.optional withLocation "PyQt5.QtPositioning"
  ++ lib.optional withSerialPort "PyQt5.QtSerialPort"
  ++ lib.optional withTools "PyQt5.QtDesigner";

  meta = {
    description = "Python bindings for Qt5";
    homepage = "https://riverbankcomputing.com/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
