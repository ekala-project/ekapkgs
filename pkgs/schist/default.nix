{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  fontconfig,
  freetype,
  libGL,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libx11,
  libxcb,
  libxi,
  libxcursor,
  libxrandr,
  addDriverRunpath,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schist";
  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/Infrawrench/schist/releases/download/v${finalAttrs.version}/schist-linux-x86_64";
    hash = "sha256-b+xmVNQXuufDu1m7/uFT+VwSoasnh05QZXNfYTWwumM=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
    libGL
    libxkbcommon
    vulkan-loader
    wayland
    libx11
    libxcb
    libxi
    libxcursor
    libxrandr
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/schist

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/schist \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          vulkan-loader
          addDriverRunpath.driverLink
        ]
      }"
  '';

  meta = {
    description = "The open source image editor that feels good to use";
    homepage = "https://github.com/Infrawrench/schist";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "schist";
  };
})
