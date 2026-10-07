{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  libpcap,
  cmake,
  openssl,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sipp";
  version = "3.7.7";

  src = fetchFromGitHub {
    owner = "SIPp";
    repo = "sipp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1JKKD3rEddCzXrbNpbzvhFXlTlkTXlP7vmRXvlGzkgI=";
  };

  postPatch = ''
    echo '#define SIPP_VERSION VERSION' > include/version.h
    echo '#define VERSION "v${finalAttrs.version}"' >> include/version.h
  '';

  cmakeEntries = {
    USE_PCAP = true;
    USE_SSL = true;
    USE_SCTP = if stdenv.hostPlatform.isLinux then "1" else "0";
    CMAKE_SKIP_BUILD_RPATH = true;
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    ncurses
    libpcap
    openssl
  ]
  ++ lib.optional (stdenv.hostPlatform.isLinux) lksctp-tools;

  meta = {
    homepage = "http://sipp.sf.net";
    description = "SIPp testing tool";
    mainProgram = "sipp";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})
