{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  kdePackages,
  pkg-config,
  writableTmpDirAsHomeHook,
  gst_all_1,
  kdsingleapplication,
  qxmpp,
  zxing-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kaidan";
  version = "0.16.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = "kaidan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-24Gls5FNOPOFg0uXidqe/FnLxraOGfT5OX6FbfdhtuQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    pkg-config
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.knotifications
    kdePackages.prison
    kdePackages.qqc2-desktop-style
    kdePackages.qtbase
    kdePackages.qtkeychain
    kdePackages.qtlocation
    kdePackages.qtmultimedia
    kdePackages.qttools
    kdePackages.sonnet
    kdsingleapplication
    qxmpp
    zxing-cpp
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
  ];

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = {
    description = "User-friendly and modern chat app, using XMPP";
    mainProgram = "kaidan";
    homepage = "https://www.kaidan.im";
    license = with lib.licenses; [
      gpl3Plus
      mit
      asl20
      cc-by-sa-40
    ];
    platforms = lib.platforms.linux;
  };
})
