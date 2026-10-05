{
  stdenv,
  fetchFromGitHub,
  fetchzip,
  sdl2-compat,
  SDL2_net,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentyrian";
  version = "2.1.20260913";

  src = fetchFromGitHub {
    owner = "opentyrian";
    repo = "opentyrian";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zAYn8/JKGtjj3REuQ3WeeKlQ+ifuhwEF7m3ixg/5154=";
  };

  data = fetchzip {
    url = "https://camanis.net/tyrian/tyrian21.zip";
    sha256 = "1biz6hf6s7qrwn8ky0g6p8w7yg715w7yklpn6258bkks1s15hpdb";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    sdl2-compat
    SDL2_net
  ];

  enableParallelBuilding = true;

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    mkdir -p $out/share/games/tyrian
    cp -r $data/* $out/share/games/tyrian/
  '';

  meta = {
    description = ''Open source port of the game "Tyrian"'';
    mainProgram = "opentyrian";
    homepage = "https://github.com/opentyrian/opentyrian";
    # This does not account of Tyrian data.
    # license = lib.licenses.gpl2;
  };
})
