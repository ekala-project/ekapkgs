{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sphinx,
  librsvg,
  qt6Packages,
  extra-cmake-modules,
  kio,
  kdsingleapplication,
  inotify-tools,
  libcloudproviders,
  libp11,
  libsecret,
  openssl,
  pcre2,
  qtkeychain,
  sqlite,
  xdg-utils,
  libsysprof-capture,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nextcloud-client";
  version = "34.0.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "nextcloud-releases";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qHhhMpgmdfNCO88ZtEtE+HcqeTOgxPUXYb8cgC6YiA=";
  };

  patches = [
    ./0001-When-creating-the-autostart-entry-do-not-use-an-abso.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"''${SYSTEMD_USER_UNIT_DIR}"' "\"$out/lib/systemd/user\""

    for file in src/libsync/vfs/*/CMakeLists.txt; do
      substituteInPlace $file \
        --replace-fail "PLUGINDIR" "KDE_INSTALL_PLUGINDIR"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    librsvg
    sphinx
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    inotify-tools
    kio
    kdsingleapplication
    libcloudproviders
    libp11
    libsecret
    openssl
    pcre2
    qt6Packages.qt5compat
    qt6Packages.qtbase
    qtkeychain
    qt6Packages.qtsvg
    qt6Packages.qttools
    qt6Packages.qtwebsockets
    qt6Packages.qtwayland
    sqlite
    libsysprof-capture
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret ]}"
    # make xdg-open overridable at runtime
    "--suffix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  cmakeEntries = {
    BUILD_UPDATER = false;
    MIRALL_VERSION_SUFFIX = "";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib") # expected to be prefix-relative by build code setting RPATH
  ];

  meta = {
    changelog = "https://github.com/nextcloud/desktop/releases/tag/v${finalAttrs.version}";
    description = "Desktop sync client for Nextcloud";
    homepage = "https://nextcloud.com";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "nextcloud";
  };
})
