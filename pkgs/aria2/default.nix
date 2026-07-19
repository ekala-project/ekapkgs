{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  gnutls,
  c-ares,
  libxml2,
  sqlite,
  zlib,
  libssh2,
  sphinx,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aria2";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-xbiNSg/Z+CA0x0DQfMNsWdA+TATyX6dCeW2Nf3L3Kfs=";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "doc"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    sphinx
  ];

  buildInputs = [
    gnutls
    c-ares
    libxml2
    sqlite
    zlib
    libssh2
  ];

  configureFlags = [
    "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
    "--enable-libaria2"
    "--with-bashcompletiondir=${placeholder "bin"}/share/bash-completion/completions"
  ];

  prePatch = ''
    patchShebangs --build doc/manual-src/en/mkapiref.py
  '';

  doCheck = false;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://aria2.github.io";
    description = "Lightweight, multi-protocol, multi-source, command-line download utility";
    mainProgram = "aria2c";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
