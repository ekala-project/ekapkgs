{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  lua,
  pkg-config,
  python3,
  zlib,
  bzip2,
  curl,
  xz,
  gettext,
  libiconv,
  icu,
  sdl2-compat,
  SDL2_mixer,
  SDL2_image,
  SDL2_ttf,
  SDL2_gfx,
  freetype,
  fluidsynth,
  sdl2Client ? false,
  gtkClient ? true,
  gtk3,
  server ? true,
  readline,
  enableSqlite ? true,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeciv";
  version = "3.2.6";

  src = fetchFromGitHub {
    owner = "freeciv";
    repo = "freeciv";
    tag = "R${lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";
    hash = "sha256-tclfdhD9fheHxeU/t2khNU+ppWZOLzJWfWR3f7wnBUk=";
  };

  postPatch = ''
    for f in {common,utility}/*.py; do
      substituteInPlace $f \
        --replace-fail '/usr/bin/env python3' ${python3.interpreter}
    done
    for f in bootstrap/*.sh; do
      patchShebangs $f
    done
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals gtkClient [ gtk3.wrapGAppsHook ];

  buildInputs = [
    lua.v5_3
    zlib
    bzip2
    curl
    xz
    gettext
    libiconv
    icu
  ]
  ++ lib.optionals sdl2Client [
    sdl2-compat
    SDL2_mixer
    SDL2_image
    SDL2_ttf
    SDL2_gfx
    freetype
    fluidsynth
  ]
  ++ lib.optionals gtkClient [ gtk3 ]
  ++ lib.optional server readline
  ++ lib.optional enableSqlite sqlite;

  dontWrapGApps = true;

  # configure is not smart enough to look for SDL2 headers under
  # .../SDL2, but thankfully $SDL2_PATH is almost exactly what we want
  preConfigure = ''
    export CPPFLAGS="$(echo $SDL2_PATH | sed 's#/nix/store/#-I/nix/store/#g')"
  '';

  configureFlags = [
    "--enable-shared"
  ]
  ++ lib.optionals sdl2Client [
    "--enable-client=sdl2"
    "--enable-sdl-mixer=sdl2"
  ]
  ++ lib.optionals gtkClient [ "--enable-client=gtk3.22" ]
  ++ lib.optional enableSqlite "--enable-fcdb=sqlite3"
  ++ lib.optional (!gtkClient) "--enable-fcmp=cli"
  ++ lib.optional (!server) "--disable-server";

  postFixup = lib.optionalString gtkClient ''
    wrapGApp $out/bin/freeciv-gtk3.22
  '';

  meta = {
    description = "Multiplayer (or single player), turn-based strategy game";
    longDescription = ''
      Freeciv is a Free and Open Source empire-building strategy game
      inspired by the history of human civilization. The game commences in
      prehistory and your mission is to lead your tribe from the stone age
      to the space age...
    '';
    homepage = "https://freeciv.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
