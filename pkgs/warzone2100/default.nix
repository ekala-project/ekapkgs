{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  p7zip,
  pkg-config,
  asciidoctor,
  gettext,
  sdl3,
  libtheora,
  libvorbis,
  libopus,
  openal,
  openal-soft,
  physfs,
  miniupnpc,
  libsodium,
  curl,
  libpng,
  freetype,
  harfbuzz,
  sqlite,
  which,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  protobuf,
  libzip,

  withVideos ? true,
}:

let
  sequences = fetchurl {
    url = "mirror://sourceforge/warzone2100/warzone2100/Videos/high-quality-en/sequences.wz";
    hash = "sha256-kP9VLKSnDiU34CfiLFCY6k7RvBG7f8lBOMbJQac9Kfo=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "warzone2100";
  version = "4.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/warzone2100/releases/${finalAttrs.version}/warzone2100_src.tar.xz";
    hash = "sha256-le5NW4hoDqGxzyMLZ+qEAo4IokWLhGBayff7nrl8Tjc=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    ninja
    p7zip
    asciidoctor
    gettext
    shaderc
  ];

  buildInputs = [
    sdl3
    libtheora
    libvorbis
    libopus
    openal
    openal-soft
    physfs
    miniupnpc
    libsodium
    curl
    libpng
    freetype
    harfbuzz
    sqlite
    protobuf
    libzip
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    vulkan-headers
    vulkan-loader
  ];

  postPatch = ''
    substituteInPlace lib/exceptionhandler/dumpinfo.cpp \
                      --replace '"which "' '"${which}/bin/which "'
    substituteInPlace lib/exceptionhandler/exceptionhandler.cpp \
                      --replace "which %s" "${which}/bin/which %s"
    substituteInPlace CMakeLists.txt \
      --replace-fail "CONFIGURE_WZ_COMPILER_WARNINGS()" ""
  '';

  cmakeEntries = {
    WZ_DISTRIBUTOR = "NixOS";
    CMAKE_INSTALL_DATAROOTDIR = "$(out)/share";
  };

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin "-P../configure_mac.cmake";

  postInstall = lib.optionalString withVideos ''
    ln -sn ${sequences} $out/share/warzone2100/sequences.wz
  '';

  meta = {
    description = "Free RTS game, originally developed by Pumpkin Studios";
    mainProgram = "warzone2100";
    longDescription = ''
        Warzone 2100 is an open source real-time strategy and real-time tactics
      hybrid computer game, originally developed by Pumpkin Studios and
      published by Eidos Interactive.
        In Warzone 2100, you command the forces of The Project in a battle to
      rebuild the world after mankind has almost been destroyed by nuclear
      missiles. The game offers campaign, multi-player, and single-player
      skirmish modes. An extensive tech tree with over 400 different
      technologies, combined with the unit design system, allows for a wide
      variety of possible units and tactics.
    '';
    homepage = "https://wz2100.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    # configure_mac.cmake tries to download stuff
    broken = stdenv.hostPlatform.isDarwin;
  };
})
