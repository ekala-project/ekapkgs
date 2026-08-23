{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  alsa-lib,
  cmake,
  libjack2,
  lhasa,
  makeWrapper,
  pkg-config,
  rtmidi,
  SDL2,
  zlib,
  zziplib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "milkytracker";
  version = "1.06";

  src = fetchFromGitHub {
    owner = "milkytracker";
    repo = "MilkyTracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IMX1+gJUghBxnaSTWnfDYzQVbKFQzQIS70H+L6ogVro=";
  };

  patches = [
    (fetchpatch2 {
      name = "0001-milkytracker-Build-SET-CMP0004-OLD-only-if-CMake-lt-4.0.patch";
      url = "https://github.com/milkytracker/MilkyTracker/commit/517b27faf6e1471c2ccb25c3c22f78eb862cd552.patch?full_index=1";
      hash = "sha256-/+Orf6BKZxhe90VT7p0gdJtHDHLrJy+rmPt03ma410s=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    lhasa
    libjack2
    rtmidi
    SDL2
    zlib
    zziplib
  ];

  postInstall = ''
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/icons/hicolor/128x128/apps/milkytracker.png
    install -Dm644 resources/org.milkytracker.MilkyTracker.metainfo.xml $out/share/appdata/org.milkytracker.MilkyTracker.metainfo.xml
  '';

  meta = {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "https://milkytracker.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "milkytracker";
  };
})
