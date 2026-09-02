{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cxxopts,
  libpulseaudio,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pamixer";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "cdemoulins";
    repo = "pamixer";
    rev = finalAttrs.version;
    hash = "sha256-LbRhsW2MiTYWSH6X9Pz9XdJdH9Na0QCO8CFmlzZmDjQ=";
  };

  postPatch = ''
    # icu76 headers (included via cxxopts) require c++17 features
    substituteInPlace meson.build \
      --replace-fail 'cpp_std=c++11' 'cpp_std=c++17'
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    boost
    cxxopts
    libpulseaudio
  ];

  meta = {
    description = "Pulseaudio command line mixer";
    homepage = "https://github.com/cdemoulins/pamixer";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "pamixer";
  };
})
