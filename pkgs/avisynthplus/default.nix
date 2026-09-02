{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  soundtouch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avisynthplus";
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RkEZWsAKZABtl+SbRLCjMqyQoi9ainbaI9hWlpO6Fwo=";
  };

  patchPhase = ''
    substituteInPlace ./avs_core/avisynth_conf.h.in \
        --replace-fail '@CORE_PLUGIN_INSTALL_PATH@' '/run/current-system/sw/lib'
  '';

  buildInputs = [
    soundtouch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Improved version of the AviSynth frameserver";
    homepage = "https://avs-plus.net/";
    changelog = "https://github.com/AviSynth/AviSynthPlus/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Only;
    pkgConfigModules = [ "avisynth" ];
    platforms = lib.platforms.unix;
  };
})
