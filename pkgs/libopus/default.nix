{
  lib,
  stdenv,
  fetchurl,
  meson,
  python3,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopus";
  version = "1.6.1";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/opus/opus-${finalAttrs.version}.tar.gz";
    hash = "sha256-b/y1kyB76SWE3xWzJGbtZLvsmRCfAHyCIF8BlFckEaE=";
  };

  patches = [ ./test-timeout.patch ];

  postPatch = ''
    patchShebangs meson/
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    python3
    ninja
  ];

  mesonBuildType = "release";
  mesonAutoFeatures = "auto";

  mesonFlags = [
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "asm" false)
  ];

  meta = {
    description = "Open, royalty-free, highly versatile audio codec";
    homepage = "https://opus-codec.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
