{
  stdenv,
  lib,
  fetchFromGitHub,
  automake,
  autoconf,
  openssl,
  zlib,
  libpcap,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcpflow";
  version = "1.6.1-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "simsong";
    repo = "tcpflow";
    rev = "8d47b53a54da58e9c9b78efed8b379d98c6113e4";
    hash = "sha256-fGKclipEU/5oAUwUWnyCVAuDjmzdExWC26qgobybz8s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    automake
    autoconf
  ];
  buildInputs = [
    openssl
    zlib
    libpcap
    boost
  ];

  prePatch = ''
    substituteInPlace bootstrap.sh \
      --replace ".git" "" \
      --replace "/bin/rm" "rm"
  '';

  preConfigure = "bash ./bootstrap.sh";

  meta = {
    description = "TCP stream extractor";
    longDescription = ''
      tcpflow is a program that captures data transmitted as part of TCP
      connections (flows), and stores the data in a way that is convenient for
      protocol analysis and debugging.
    '';
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "tcpflow";
  };
})
