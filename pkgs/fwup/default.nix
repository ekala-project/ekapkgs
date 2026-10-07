{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  bzip2,
  libarchive,
  libconfuse,
  libsodium,
  xz,
  zlib,
  dosfstools,
  mtools,
  unzip,
  zip,
  which,
  xdelta,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwup";
  version = "1.17.1";

  src = fetchFromGitHub {
    owner = "fwup-home";
    repo = "fwup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xs2aChvYa1Dn90hhlwhd5tec9BcZMPvvQSucvlxE6gg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    bzip2
    libarchive
    libconfuse
    libsodium
    xz
    zlib
  ];

  nativeCheckInputs = [
    dosfstools
    mtools
    unzip
    which
    xdelta
    zip
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    changelog = "https://github.com/fwup-home/fwup/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fwup-home/fwup";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
