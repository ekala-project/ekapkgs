{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  polkit-qt-1,
  qt6,
  tzdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-admin";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-admin";
    tag = finalAttrs.version;
    hash = "sha256-SNEOqyLIDlOio4LttsCUgC/EnGcCSDTwPxhJo1lEvJE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    liblxqt
    libqtxdg
    polkit-qt-1
    qt6.qtsvg
    qt6.qtwayland
  ];

  cmakeEntries = {
    # fake finding of libsystemd; used to check if we are a systemd-based
    # distro rather than actually being linked to
    LIBSYSTEMD_FOUND = true;
  };

  postPatch = ''
    for f in lxqt-admin-{time,user}/CMakeLists.txt; do
      substituteInPlace $f --replace-fail \
        "\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}" \
        "$out/share/polkit-1/actions"
    done

    # patch timezone database file location
    substituteInPlace lxqt-admin-time/timeadmindialog.cpp \
      --replace-fail "/usr/share/zoneinfo/zone.tab" "${tzdata}/share/zoneinfo/zone.tab"
  '';

  meta = {
    homepage = "https://github.com/lxqt/lxqt-admin";
    description = "LXQt system administration tool";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
