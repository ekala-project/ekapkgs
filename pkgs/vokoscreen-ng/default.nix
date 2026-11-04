{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gstreamer,
  libx11,
  pipewire,
  pulseaudio,
  qt6,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vokoscreen-ng";
  version = "4.10.0";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    tag = finalAttrs.version;
    hash = "sha256-Sp6MHX9+VHdWEG/lspoTnJCPr+J3rAHgSPgvTR+xqqQ=";
  };

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [
    qt6.qttools
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    gstreamer
    libx11
    pulseaudio
    qt6.qtbase
    qt6.qtmultimedia
    wayland
    pipewire
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    gstreamer.plugins-ugly
  ];

  preBuild = ''
    lrelease src/language/*.ts
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin vokoscreenNG
    install -Dm644 -t $out/share/applications src/applications/vokoscreenNG.desktop
    install -Dm644 -t $out/share/icons src/applications/vokoscreenNG.png

    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")

    runHook postInstall
  '';

  meta = {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = lib.licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    platforms = lib.platforms.linux;
    mainProgram = "vokoscreenNG";
  };
})
