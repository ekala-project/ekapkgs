{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fftw,
  gettext,
  ncurses,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "httping";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "folkertvanheusden";
    repo = "HTTPing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qvi+8HwEipI8vkhPgFSN+q+3BsUCQTOqPVUUzzDn3Uo=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    gettext
  ];

  buildInputs = [
    fftw
    ncurses
    openssl
  ];

  installPhase = ''
    runHook preInstall
    install -D httping $out/bin/httping
    runHook postInstall
  '';

  meta = {
    description = "Ping with HTTP requests";
    homepage = "https://vanheusden.com/httping";
    license = lib.licenses.agpl3Only;
    mainProgram = "httping";
    platforms = lib.platforms.linux;
  };
})
