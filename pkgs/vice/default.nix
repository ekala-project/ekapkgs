{
  lib,
  stdenv,
  fetchurl,
  bison,
  flex,
  perl,
  curl,
  libpng,
  giflib,
  alsa-lib,
  readline,
  libGLU,
  libGL,
  pkg-config,
  SDL2,
  SDL2_image,
  dos2unix,
  xa,
  file,
  xdg-utils,
  libevdev,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vice";
  version = "3.10";

  src = fetchurl {
    url = "mirror://sourceforge/vice-emu/vice-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-jlusGMvLnxkjgK0++IH4eQ9bdcQdez2mXYMZhdhk1tE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bison
    dos2unix
    file
    flex
    perl
    pkg-config
    xa
    xdg-utils
  ];

  buildInputs = [
    alsa-lib
    curl
    giflib
    libevdev
    libGL
    libGLU
    libpng
    libpulseaudio
    readline
    SDL2
    SDL2_image
  ];

  configureFlags = [
    "--enable-sdl2ui"
    "--disable-gtk3ui"
    "--disable-desktop-files"
    "--disable-pdf-docs"
    "--with-gif"
  ];

  env.LIBS = "-lGL";

  preConfigure = ''
    patchShebangs .
  '';

  enableParallelBuilding = true;

  postInstall = ''
    for binary in vsid x128 x64 x64dtv xcbm2 xpet xplus4 xscpu64 xvic; do
      for size in 16 24 32 48 64 256; do
        install -D data/common/vice-''${binary}_''${size}.png $out/share/icons/hicolor/''${size}x''${size}/apps/vice-''${binary}.png
      done
      install -D data/common/vice-''${binary}_1024.svg $out/share/icons/hicolor/scalable/apps/vice-''${binary}.svg
    done
  '';

  meta = {
    description = "Emulators for a variety of 8-bit Commodore computers";
    homepage = "https://vice-emu.sourceforge.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
