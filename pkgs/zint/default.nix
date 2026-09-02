{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libpng,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zint";
  version = "2.15.0";

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "zint";
    repo = "zint";
    tag = finalAttrs.version;
    hash = "sha256-+dXIU66HIS2mE0pa99UemMMFBGCYjupUX8P7q3G7Nis=";
  };

  patches = [
    ./fix-installation-of-cmake-files.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
  ];

  propagatedBuildInputs = [
    libpng
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "ZINT_QT6" false)
    (lib.cmakeBool "ZINT_FRONTEND" true)
  ];

  meta = {
    description = "Barcode generating tool and library";
    homepage = "https://www.zint.org.uk";
    changelog = "https://github.com/zint/zint/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "zint";
  };
})
