{
  stdenv,
  lib,
  fetchFromGitHub,
  libcap,
  libsodium,
  openssl,
  zlib,
  perl,
  ncurses,
  libxcrypt-legacy,
  removeReferencesTo,
}:

let
  perl' = perl.override {
    libxcrypt = libxcrypt-legacy;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "proftpd";
  version = "1.3.9d";

  src = fetchFromGitHub {
    owner = "proftpd";
    repo = "proftpd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e0E775p8+UdLy9YqdeY5NJGYn8ojWtvOLVAr+UkTEv0=";
  };

  patches = [ ./no-install-user.patch ];

  strictDeps = true;

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    libcap
    libsodium
    openssl
    zlib
    perl'
    ncurses
  ];

  nativeBuildInputs = [ removeReferencesTo ];

  configureFlags = [
    "--enable-openssl"
    "--with-modules=mod_sftp"
  ];

  postInstall = ''
    patchShebangs $out/bin
    rm $out/bin/prxs
    rm -r $out/{var,share,libexec}
  '';

  postFixup = ''
    remove-references-to -t $dev $out/bin/*
  '';

  meta = {
    homepage = "http://www.proftpd.org/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "proftpd";
    platforms = lib.platforms.unix;
    description = "Highly configurable GPL-licensed FTP server software";
  };
})
