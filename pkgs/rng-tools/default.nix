{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  pkg-config,
  openssl,
  libcap,
  libp11,
  opensc,
}:

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.17";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = "rng-tools";
    rev = "v${version}";
    hash = "sha256-wqJvLvxmNG2nb5P525w25Y8byUUJi24QIHNJomCKeG8=";
  };

  nativeBuildInputs = [
    autoreconfHook
    libtool
    pkg-config
  ];

  buildInputs = [
    openssl
    libcap
    libp11
  ];

  configureFlags = [
    "--disable-jitterentropy"
    "--without-nistbeacon"
    "--with-pkcs11"
    "--without-rtlsdr"
    "--without-qrypt"
  ];

  enableParallelBuilding = true;

  makeFlags = [
    "AR:=$(AR)"
    "PKCS11_ENGINE=${opensc}/lib/opensc-pkcs11.so"
  ];

  doCheck = false;

  meta = {
    description = "Random number generator daemon";
    homepage = "https://github.com/nhorman/rng-tools";
    changelog = "https://github.com/nhorman/rng-tools/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
