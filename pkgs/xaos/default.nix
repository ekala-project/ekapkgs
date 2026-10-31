{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  copyDesktopItems,
}:

let
  datapath = "$out/share/XaoS";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "xaos";
  version = "4.3.8";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "xaos-project";
    repo = "XaoS";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-FNeeU1ffNYBwUxtAmvtJWZwXK6mMGFz/Dq2+JdrVHTI=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [ qt6.qtbase ];

  env = {
    QMAKE_LRELEASE = "lrelease";

    DEFINES = toString [
      "USE_OPENGL"
      "USE_FLOAT128"
    ];
  };

  postPatch = ''
    substituteInPlace src/include/config.h \
      --replace-fail "/usr/share/XaoS" "${datapath}"
  '';

  desktopItems = [ "xdg/io.github.xaos_project.XaoS.desktop" ];

  postInstall = ''
    mkdir -p "${datapath}"
    cp -r tutorial examples catalogs "${datapath}"
    install -D "xdg/xaos.png" "$out/share/icons/xaos.png"
  '';

  meta = {
    description = "Real-time interactive fractal zoomer";
    mainProgram = "xaos";
    homepage = "https://xaos-project.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
