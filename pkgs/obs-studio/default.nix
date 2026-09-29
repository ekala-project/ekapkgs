{
  lib,
  stdenv,
  uthash,
  ninja,
  nv-codec-headers-12,
  fetchFromGitHub,
  addDriverRunpath,
  cmake,
  fdk_aac,
  ffmpeg,
  jansson,
  libjack2,
  libxkbcommon,
  libpthread-stubs,
  libxdmcp,
  qt6,
  speex,
  libv4l,
  x264,
  curl,
  wayland,
  libx11,
  pkg-config,
  libGL,
  mbedtls,
  gtk3,
  scriptingSupport ? true,
  luajit,
  swig,
  python3,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  pulseaudioSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  withFdk ? true,
  pipewire,
  libdrm,
  librist,
  cjson,
  libva,
  srt,
  nlohmann_json,
  websocketpp,
  asio,
  libdatachannel,
  libvpl,
  qrcodegencpp,
  simde,
  extra-cmake-modules,
  pciutils,
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "obs-studio";
  version = "32.2.1";

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = finalAttrs.version;
    hash = "sha256-MpwywBxZvj7rUIt7eu1KMLdFt/1B0es7ug/t+J26Jz8=";
    fetchSubmodules = true;
  };

  separateDebugInfo = true;

  patches = [
    ./fix-nix-plugin-path.patch
  ];

  nativeBuildInputs = [
    addDriverRunpath
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    gtk3.wrapGAppsHook
    qt6.wrapQtAppsHook
    extra-cmake-modules
  ]
  ++ optional scriptingSupport swig
  ++ optional scriptingSupport python3;

  buildInputs = [
    curl
    ffmpeg
    jansson
    libjack2
    libv4l
    libxkbcommon
    libpthread-stubs
    libxdmcp
    qt6.qtbase
    qt6.qtsvg
    speex
    wayland
    x264
    mbedtls
    pciutils
    librist
    cjson
    libva
    srt
    qt6.qtwayland
    nlohmann_json
    websocketpp
    asio
    libdatachannel
    libvpl
    uthash
    nv-codec-headers-12
    qrcodegencpp
  ]
  ++ optionals scriptingSupport [
    luajit
    python3
  ]
  ++ optional alsaSupport alsa-lib
  ++ optional pulseaudioSupport libpulseaudio
  ++ optionals pipewireSupport [
    pipewire
    libdrm
  ]
  ++ optional withFdk fdk_aac;

  propagatedBuildInputs = [ simde ];

  postPatch = ''
    cp ${./CMakeUserPresets.json} ./CMakeUserPresets.json
  '';

  cmakeFlags = [
    "--preset"
    "nixpkgs-linux"
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev"
    "-DECM_DIR=${extra-cmake-modules}/share/ECM/cmake"
    "-DENABLE_JACK=ON"
    "-DENABLE_WEBRTC=ON"
    (lib.cmakeBool "ENABLE_QSV11" stdenv.hostPlatform.isx86_64)
    (lib.cmakeBool "ENABLE_LIBFDK" withFdk)
    (lib.cmakeBool "ENABLE_SCRIPTING" scriptingSupport)
    (lib.cmakeBool "ENABLE_ALSA" alsaSupport)
    (lib.cmakeBool "ENABLE_PULSEAUDIO" pulseaudioSupport)
    (lib.cmakeBool "ENABLE_PIPEWIRE" pipewireSupport)
    (lib.cmakeBool "ENABLE_AJA" false)
    (lib.cmakeBool "ENABLE_BROWSER" false)
    (lib.cmakeBool "ENABLE_VLC" false)
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=sign-compare"
    "-Wno-error=stringop-overflow="
  ];

  dontWrapGApps = true;
  preFixup =
    let
      wrapperLibraries = [
        libx11
        libGL
      ];
    in
    ''
      qtWrapperArgs+=(
        --prefix LD_LIBRARY_PATH : "$out/lib:${lib.makeLibraryPath wrapperLibraries}"
        ''${gappsWrapperArgs[@]}
      )
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addDriverRunpath $out/lib/lib*.so
    addDriverRunpath $out/lib/obs-plugins/*.so
  '';

  meta = {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    changelog = "https://github.com/obsproject/obs-studio/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ gpl2Plus ] ++ optional withFdk fraunhofer-fdk;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    mainProgram = "obs";
  };
})
