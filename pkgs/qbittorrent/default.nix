{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  boost,
  libtorrent-rasterbar,
  openssl,
  qt6,
  zlib,
  dbus,
  python3,
  guiSupport ? true,
  trackerSearch ? true,
  webuiSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qbittorrent" + lib.optionalString (!guiSupport) "-nox";
  version = "5.2.3";

  src = fetchFromGitHub {
    owner = "qbittorrent";
    repo = "qBittorrent";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-K6YnqKHVo+notbjKxnzcN1DEcpAa2KMge4Ov30poEQY=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    wrapGAppsHook3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libtorrent-rasterbar
    openssl
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    zlib
  ]
  ++ lib.optionals guiSupport [ dbus ]
  ++ lib.optionals (guiSupport && stdenv.hostPlatform.isLinux) [ qt6.qtwayland ]
  ++ lib.optionals trackerSearch [ python3 ];

  cmakeFlags = [
    "-DVERBOSE_CONFIGURE=ON"
  ]
  ++ lib.optionals (!guiSupport) [
    "-DGUI=OFF"
    "-DSYSTEMD=ON"
    "-DSYSTEMD_SERVICES_INSTALL_DIR=${placeholder "out"}/lib/systemd/system"
  ]
  ++ lib.optionals (!webuiSupport) [ "-DWEBUI=OFF" ];

  qtWrapperArgs = lib.optionals trackerSearch [
    "--prefix PATH : ${lib.makeBinPath [ python3 ]}"
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Featureful free software BitTorrent client";
    homepage = "https://www.qbittorrent.org";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "qbittorrent" + lib.optionalString (!guiSupport) "-nox";
  };
})
