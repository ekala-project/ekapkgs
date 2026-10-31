{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  exiv2,
  libraw,
  libtiff,
  opencv4,
  pkg-config,
  qt6,
  quazip,
  kdePackages,
  rsync,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nomacs";
  version = "3.23.3";

  src = fetchFromGitHub {
    owner = "nomacs";
    repo = "nomacs";
    rev = finalAttrs.version;
    fetchSubmodules = false;
    hash = "sha256-Liv09fgwQs6c0mA/35I+fAQV32SrG4gnFTewftfn/h8=";
  };

  sourceRoot = "${finalAttrs.src.name}/ImageLounge";

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    exiv2
    libraw
    libtiff
    (lib.getOutput "cxxdev" opencv4)
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtsvg
    qt6.qttools
    quazip
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    kdePackages.kimageformats
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_OPENCV" true)
    (lib.cmakeBool "ENABLE_QUAZIP" true)
    (lib.cmakeBool "ENABLE_RAW" true)
    (lib.cmakeBool "ENABLE_TIFF" true)
    (lib.cmakeBool "ENABLE_TRANSLATIONS" true)
    (lib.cmakeBool "USE_SYSTEM_QUAZIP" true)
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mv $out/lib/nomacs-plugins $out/bin/plugins
  '';

  meta = {
    homepage = "https://nomacs.org";
    description = "Qt-based image viewer";
    changelog = "https://github.com/nomacs/nomacs/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nomacs";
    platforms = lib.platforms.linux;
  };
})
