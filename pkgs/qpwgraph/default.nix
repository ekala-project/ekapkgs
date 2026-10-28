{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  alsa-lib,
  pipewire,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qpwgraph";
  version = "1.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "rncbc";
    repo = "qpwgraph";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-KZXKGujfn6IZff28eMmM+UwH1+T3/mEOiysecwWOO1o=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    alsa-lib
    pipewire
  ];

  cmakeEntries = {
    CONFIG_WAYLAND = true;
  };

  meta = {
    description = "Qt graph manager for PipeWire, similar to QjackCtl";
    longDescription = ''
      qpwgraph is a graph manager dedicated for PipeWire,
      using the Qt C++ framework, based and pretty much like
      the same of QjackCtl.
    '';
    homepage = "https://gitlab.freedesktop.org/rncbc/qpwgraph";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "qpwgraph";
  };
})
