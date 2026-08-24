{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  pkg-config,
  rustPlatform,
  bzip2,
  curl,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-cinnabar";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    tag = finalAttrs.version;
    hash = "sha256-wZrRcuQMKRPtiJC59E54jXhp8yFPb63yuNfTwVDBCPQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    bzip2
    curl
    zlib
    zstd
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-+6/UwbOYE7Ik4sdTU2WI3jDhKNh74hF3Cbm+9V5uizc=";
  };

  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  enableParallelBuilding = true;

  # Disable automated version-check
  buildNoDefaultFeatures = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -v target/release/git-cinnabar $out/bin
    ln -sv git-cinnabar $out/bin/git-remote-hg

    runHook postInstall
  '';

  meta = {
    description = "Git remote helper to interact with mercurial repositories";
    homepage = "https://github.com/glandium/git-cinnabar";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
