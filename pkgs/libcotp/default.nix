{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libgcrypt,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libcotp";
  version = "4.2.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "paolostivanin";
    repo = "libcotp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qHHrINqH+bq7af/5lUwnj/VYkwunr+4WCBocwq60hPM=";
  };

  buildInputs = [ libgcrypt ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  meta = {
    description = "C library that generates TOTP and HOTP";
    homepage = "https://github.com/paolostivanin/libcotp";
    changelog = "https://github.com/paolostivanin/libcotp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
