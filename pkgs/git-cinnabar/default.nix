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
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "glandium";
    repo = "git-cinnabar";
    tag = finalAttrs.version;
    hash = "sha256-ZZJWP4MXmkA/tTACvPYwL8UDw/s14R/FYjBWZPzbCUE=";
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
    hash = "sha256-Kg5bcvobsOQT8Fhe0hIM4WPCXsykoYAe0Nn/f1dlgcs=";
  };

  env.ZSTD_SYS_USE_PKG_CONFIG = true;


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
    platforms = lib.platforms.all;
  };
})
