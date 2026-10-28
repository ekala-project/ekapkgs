{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  qt6,
  pkg-config,
  karchive,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdoctools,
  ki18n,
  kiconthemes,
  kio,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
  alsa-lib,
  audiofile,
  fftw,
  flac,
  id3lib,
  libogg,
  libopus,
  libmad,
  libpulseaudio,
  libsamplerate,
  libvorbis,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwave";
  version = "26.08.2";

  src = fetchurl {
    url = "mirror://kde/stable/release-service/${finalAttrs.version}/src/kwave-${finalAttrs.version}.tar.xz";
    hash = "sha256-1P9jMwPocODpxZ63rfxLL1rYK2z7NKSzbeZUjHCEWng=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
    pkg-config
    kdoctools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    karchive
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kcrash
    kdbusaddons
    ki18n
    kiconthemes
    kio
    ktextwidgets
    kwidgetsaddons
    kxmlgui
    alsa-lib
    audiofile
    fftw
    flac
    id3lib
    libogg
    libopus
    libmad
    libpulseaudio
    libsamplerate
    libvorbis
  ];

  meta = {
    description = "Sound editor by KDE";
    homepage = "https://apps.kde.org/kwave/";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kwave";
  };
})
