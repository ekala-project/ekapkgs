{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  sphinx,
  buildPackages,
  ffmpeg-headless,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unpaper";
  version = "7.0.0";

  src = fetchurl {
    url = "https://www.flameeyes.eu/files/unpaper-${finalAttrs.version}.tar.xz";
    hash = "sha256-JXX7vybCJxnRy4grWWAsmQDH90cRisEwiD9jQZvkaoA=";
  };

  outputs = [
    "out"
    "man"
  ];

  nativeBuildInputs = [
    buildPackages.libxslt.bin
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    ffmpeg-headless
  ];

  doCheck = false;

  meta = {
    homepage = "https://www.flameeyes.eu/projects/unpaper";
    changelog = "https://github.com/unpaper/unpaper/blob/unpaper-${finalAttrs.version}/NEWS";
    description = "Post-processing tool for scanned sheets of paper";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    mainProgram = "unpaper";
  };
})
