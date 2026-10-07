{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  nss,
  p11-kit,
  which,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkcs11-provider";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "openssl-projects";
    repo = "pkcs11-provider";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-//sVGWSXCRc7zimD78ykoyJ0gQk/LFrdf+A6yKJkxGs=";
  };

  buildInputs = [
    openssl
    nss
    p11-kit
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    which
  ];

  postPatch = ''
    patchShebangs --build .
  '';

  preInstall = ''
    mkdir -p "$out"
    for dir in "$out" "${openssl.out}"; do
      mkdir -p .install/"$(dirname -- "$dir")"
      ln -s "$out" ".install/$dir"
    done
    export DESTDIR="$(realpath .install)"
  '';

  enableParallelInstalling = false;

  doCheck = false;

  meta = {
    homepage = "https://github.com/latchset/pkcs11-provider";
    description = "OpenSSL 3.x provider to access hardware or software tokens using the PKCS#11 Cryptographic Token Interface";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
