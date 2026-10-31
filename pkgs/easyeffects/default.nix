{
  lib,
  stdenv,
  calf,
  cmake,
  deepfilternet,
  fetchFromGitHub,
  fftw,
  fftwFloat,
  glib,
  gsl,
  intltool,
  kdePackages,
  ladspa-header,
  libbs2b,
  libebur128,
  libmysofa,
  libsigcxx_3_0,
  libsndfile,
  lilv,
  lsp-plugins,
  lv2,
  ninja,
  nlohmann_json,
  pipewire,
  pkg-config,
  qt6,
  rnnoise,
  rubberband,
  soundtouch,
  speexdsp,
  onetbb,
  webrtc-audio-processing,
  x42-plugins,
  zam-plugins,
  zita-convolver,
  wrapGAppsHook3,
}:

let
  inherit (qt6)
    qtbase
    qtgraphs
    wrapQtAppsHook
    ;
  inherit (kdePackages)
    breeze
    breeze-icons
    extra-cmake-modules
    kcolorscheme
    kconfigwidgets
    kiconthemes
    kirigami
    kirigami-addons
    qqc2-desktop-style
    ;
  speexdsp' = speexdsp.override { withFftw3 = false; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "easyeffects";
  version = "8.3.0";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8SAmWeLK4eAtjoNzrlK+8qvshCY/T96KNk+oHBYdv9Q=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    intltool
    ninja
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
    breeze
    breeze-icons
    deepfilternet
    fftw
    fftwFloat
    glib
    gsl
    kcolorscheme
    kconfigwidgets
    kiconthemes
    kirigami
    kirigami-addons
    ladspa-header
    qqc2-desktop-style
    libbs2b
    libebur128
    libmysofa
    libsigcxx_3_0
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    qtbase
    qtgraphs
    rnnoise
    rubberband
    soundtouch
    speexdsp'
    onetbb
    webrtc-audio-processing
    zita-convolver
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [
    x42-plugins
  ];

  preFixup =
    let
      lv2Plugins = [
        calf
        lsp-plugins
        zam-plugins
      ]
      ++ lib.optionals stdenv.hostPlatform.isx86 [
        x42-plugins
      ];

      ladspaPlugins = [
        deepfilternet
        rubberband
      ];
    in
    ''
      qtWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
        --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
        --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
      )
    '';

  separateDebugInfo = true;

  meta = {
    description = "Audio effects for PipeWire applications";
    homepage = "https://github.com/wwmm/easyeffects";
    license = lib.licenses.gpl3Plus;
    mainProgram = "easyeffects";
    platforms = lib.platforms.linux;
  };
})
