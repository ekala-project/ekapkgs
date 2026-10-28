{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsodium,
  opus,
  libvpx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "toxcore";
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "TokTok";
    repo = "c-toxcore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t5dUIxYq94tamySm7VIat/SlD1JnjKOdr2x7Wznh/cU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    libsodium
    opus
    libvpx
  ];

  cmakeEntries = {
    BOOTSTRAP_DAEMON = false;
  };

  meta = {
    description = "P2P FOSS instant messaging application aimed to replace Skype - core library";
    homepage = "https://tox.chat/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})
