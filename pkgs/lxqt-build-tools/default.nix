{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6,
  glib,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-build-tools";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-build-tools";
    tag = finalAttrs.version;
    hash = "sha256-PvDXL4hHaHeHt7CXeNCj8L2bv3YYY78ZDTxsctc73fo=";
  };

  postPatch = ''
    # Nix clang on darwin identifies as 'Clang', not 'AppleClang'
    # Without this, dependants fail to link.
    substituteInPlace cmake/modules/LXQtCompilerSettings.cmake \
      --replace-fail AppleClang Clang
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    glib
  ];

  propagatedBuildInputs = [
    perl # needed by LXQtTranslateDesktop.cmake
  ];

  setupHook = ./setup-hook.sh;

  # We're dependent on this macro doing add_definitions in most places
  # But we have the setup-hook to set the values.
  postInstall = ''
    cp ${./LXQtConfigVars.cmake} $out/share/cmake/lxqt2-build-tools/modules/LXQtConfigVars.cmake
  '';

  meta = {
    homepage = "https://github.com/lxqt/lxqt-build-tools";
    description = "Various packaging tools and scripts for LXQt applications";
    mainProgram = "lxqt-transupdate";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
})
