{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  libxscrnsaver,
  libqtxdg,
  lxqt-build-tools,
  polkit-qt-1,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liblxqt";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "liblxqt";
    tag = finalAttrs.version;
    hash = "sha256-kGKgKpgiK40933O3T/astH0X1Y4oIH6kEKjjMBh43MA=";
  };

  # convert name of wrapped binary, e.g. .lxqt-whatever-wrapped to the original name, e.g. lxqt-whatever so binaries can find their resources
  patches = [ ./fix-application-path.patch ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/119766
    substituteInPlace lxqtbacklight/linux_backend/driver/libbacklight_backend.c \
      --replace-fail "pkexec lxqt-backlight_backend" "pkexec $out/bin/lxqt-backlight_backend"

    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    libxscrnsaver
    libqtxdg
    polkit-qt-1
    qt6.qtsvg
  ];

  meta = {
    description = "Core utility library for all LXQt components";
    mainProgram = "lxqt-backlight_backend";
    homepage = "https://github.com/lxqt/liblxqt";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
