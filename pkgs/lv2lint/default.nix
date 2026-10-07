{
  stdenv,
  lib,
  fetchFromSourcehut,
  pkg-config,
  meson,
  ninja,
  lv2,
  lilv,
  curl,
  elfutils,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lv2lint";
  version = "0.16.2";

  src = fetchFromSourcehut {
    domain = "open-music-kontrollers.ch";
    owner = "~hp";
    repo = "lv2lint";
    tag = finalAttrs.version;
    hash = "sha256-NkzbKteLZ+P+Py+CMOYYipvu6psDslWnM1MAV1XB0TM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    lv2
    lilv
    curl
    elfutils
    libx11
  ];

  mesonFeatures = {
    online-tests = true;
    elf-tests = true;
    x11-tests = true;
  };

  meta = {
    description = "Check whether a given LV2 plugin is up to the specification";
    homepage = "https://git.open-music-kontrollers.ch/~hp/lv2lint";
    license = lib.licenses.artistic2;
    platforms = lib.platforms.linux;
    mainProgram = "lv2lint";
  };
})
