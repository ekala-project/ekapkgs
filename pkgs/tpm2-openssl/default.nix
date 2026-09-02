{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  autoconf-archive,
  pkg-config,
  openssl,
  tpm2-tss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-openssl";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-openssl";
    rev = finalAttrs.version;
    hash = "sha256-CCTR7qBqI/y+jLBEEcgRanYOBNUYM/sH/hCqOLGA4QM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    openssl
    tpm2-tss
  ];

  configureFlags = [ "--with-modulesdir=$$out/lib/ossl-modules" ];

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';
  meta = {
    description = "OpenSSL Provider for TPM2 integration";
    homepage = "https://github.com/tpm2-software/tpm2-openssl";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
