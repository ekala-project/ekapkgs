{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsndfile,
  libsamplerate,
  flex,
  bison,
  boost,
  gettext,
  alsa-lib ? null,
  libpulseaudio ? null,
  libjack2 ? null,
  liblo ? null,
  ladspa-sdk ? null,
  eigen ? null,
  curl ? null,
  tcltk ? null,
  fltk ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "csound";
  version = "7.0.0-beta.10";

  hardeningDisable = [ "format" ];

  src = fetchFromGitHub {
    owner = "csound";
    repo = "csound";
    tag = finalAttrs.version;
    hash = "sha256-l3dSVt5rgyj98ZCZltqKAJx/0Afl4R03flLXBcivtwg=";
  };

  cmakeFlags = [
    "-DBUILD_CSOUND_AC=0"
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    flex
    bison
    gettext
  ];
  buildInputs = [
    libsndfile
    libsamplerate
    boost
  ]
  ++ (builtins.filter (optional: optional != null) [
    alsa-lib
    libpulseaudio
    libjack2
    liblo
    ladspa-sdk
    eigen
    curl
    tcltk
    fltk
  ]);

  meta = {
    description = "Sound design, audio synthesis, and signal processing system, providing facilities for music composition and performance on all major operating systems and platforms";
    homepage = "https://csound.com/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
