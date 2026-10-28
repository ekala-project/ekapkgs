{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  libarchive,
  libxdmcp,
  libpthread-stubs,
  libxcb-keysyms,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zeal";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UvgvPeBShlBCTKbTNz3LbV2hUOGov6a66D/Cpe2I12s=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libxdmcp
    libarchive
    libpthread-stubs
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtwebengine
    libxcb-keysyms
  ];

  cmakeEntries = {
    ZEAL_RELEASE_BUILD = true;
  };

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/{Applications,bin}
    cp -r Zeal.app $out/Applications
    ln -s $out/Applications/Zeal.app/Contents/MacOS/Zeal $out/bin/zeal

    runHook postInstall
  '';

  meta = {
    description = "Simple offline API documentation browser";
    longDescription = ''
      Zeal is a simple offline API documentation browser inspired by Dash (macOS
      app), available for Linux and Windows.
    '';
    homepage = "https://zealdocs.org/";
    changelog = "https://github.com/zealdocs/zeal/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "zeal";
    inherit (qt6.qtbase.meta) platforms;
  };
})
