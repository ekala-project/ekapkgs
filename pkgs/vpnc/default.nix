{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  perl,
  gnutls,
  libgcrypt,
  vpnc-scripts ? null,
  opensslSupport ? false,
  openssl,
}:

stdenv.mkDerivation {
  pname = "vpnc";
  version = "0-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "streambinder";
    repo = "vpnc";
    rev = "6a70db13f6e9201101e1c4890393566be6000e6a";
    sha256 = "sha256-8XgEoQn7hz/eU7w+jqxYUBuOpAQlc+2qTj1mcDMHK30=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ]
  ++ lib.optional (!opensslSupport) pkg-config;

  buildInputs = [
    libgcrypt
    perl
  ]
  ++ (if opensslSupport then [ openssl ] else [ gnutls ]);

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc/vpnc"
  ]
  ++ lib.optionals (vpnc-scripts != null) [
    "SCRIPT_PATH=${vpnc-scripts}/bin/vpnc-script"
  ]
  ++ lib.optional opensslSupport "OPENSSL_GPL_VIOLATION=yes";

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postPatch = ''
    substituteInPlace src/vpnc-disconnect \
      --replace-fail /bin/sh ${lib.getExe' bash "sh"}
    patchShebangs src/makeman.pl
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = false;
  strictDeps = true;

  meta = {
    homepage = "https://davidepucci.it/doc/vpnc/";
    description = "Virtual private network (VPN) client for Cisco's VPN concentrators";
    license = if opensslSupport then lib.licenses.unfree else lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
