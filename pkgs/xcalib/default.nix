{
  lib,
  stdenv,
  fetchFromCodeberg,
  fetchpatch,
  cmake,
  ninja,
  libx11,
  libxxf86vm,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcalib";
  version = "0.11";

  src = fetchFromCodeberg {
    owner = "OpenICC";
    repo = "xcalib";
    tag = finalAttrs.version;
    hash = "sha256-o0pizV4Qrb9wfVKVNH2Ifb9tr7N7iveVHQB39WVCl8w=";
  };

  patches = [
    (fetchpatch {
      url = "https://codeberg.org/OpenICC/xcalib/commit/e8566ead8c043b5f0003c3613b91deab6430eac8.patch";
      hash = "sha256-gZc4itfsP5T68ZucdYJWJ4sL11xFaw5ePABsmEYHxrU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libx11
    libxxf86vm
    libxrandr
  ];

  meta = {
    description = "Tiny monitor calibration loader for X and MS-Windows";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "xcalib";
  };
})
