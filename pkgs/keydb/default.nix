{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  openssl,
  libuuid,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "keydb";
  version = "6.3.4";

  src = fetchFromGitHub {
    owner = "Snapchat";
    repo = "KeyDB";
    rev = "v${finalAttrs.version}";
    hash = "sha256-j6qgK6P3Fv+b6k9jwKQ5zW7XLkKbXXcmHKBCQYvwEIU=";
  };

  nativeBuildInputs = [ pkg-config ];

  # TLS is on by default; the rocksdb-backed FLASH storage is off by default
  # and its git submodule is not shipped in the release tarball.
  buildInputs = [
    openssl
    libuuid
    curl
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "BUILD_TLS=yes"
  ];

  enableParallelBuilding = true;

  doCheck = false;

  meta = {
    homepage = "https://keydb.dev/";
    description = "Multithreaded fork of Redis focused on high performance";
    changelog = "https://github.com/Snapchat/KeyDB/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "keydb-server";
  };
})
