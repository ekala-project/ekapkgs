{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opus";
  version = "1.5.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZcHS94ufL7IAgsOMvkfJUa1YOTRYduRpQWEu6H+afOE=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    python3
  ];

  postPatch = ''
    patchShebangs meson
  '';

  mesonBuildType = "release";

  mesonAutoFeatures = "auto";

  mesonFlags = [
    "-Dasm=disabled"
    "-Ddocs=disabled"
  ];

  meta = {
    description = "Modern audio compression for the internet";
    homepage = "https://opus-codec.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
})
