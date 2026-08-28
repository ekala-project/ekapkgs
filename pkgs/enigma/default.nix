{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  makeWrapper,
  pkg-config,
  gettext,
  imagemagick,
  curl,
  libpng,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_ttf,
  xercesc,
  xdg-utils,
}:

let
  SDL2_mixer' = SDL2_mixer.override { fluidsynth = null; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "enigma";
  version = "1.30";

  src = fetchurl {
    url = "https://github.com/Enigma-Game/Enigma/releases/download/${finalAttrs.version}/Enigma-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-rmS5H7wrEJcAcdDXjtW07enuOGjeLm6VaVRvxYQ3+K8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Enigma-Game/Enigma/pull/70/commits/d25051eb6228c885e779a9674f8ee3979da30663.patch";
      hash = "sha256-L5C4NCZDDUKji9Tg4geKaiw3CkSY6rCoawqGKqR4dFM=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    makeWrapper
    imagemagick
  ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer'
    SDL2_ttf
    libpng
    xercesc
    curl
    xdg-utils
  ];

  preConfigure = ''
    export SDL_CFLAGS=$(sdl2-config --cflags)
  '';

  postInstall = ''
    rm -r $out/include
    wrapProgram $out/bin/enigma --suffix PATH : "${lib.makeBinPath [ xdg-utils ]}"
  '';

  meta = {
    description = "Puzzle game inspired by Oxyd on the Atari ST and Rock'n'Roll on the Amiga";
    mainProgram = "enigma";
    license = with lib.licenses; [
      gpl2
      free
    ];
    platforms = lib.platforms.linux;
    homepage = "https://www.nongnu.org/enigma/";
  };
})
