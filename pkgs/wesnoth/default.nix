{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  sdl2-compat,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_ttf,
  pango,
  gettext,
  boost,
  libvorbis,
  fribidi,
  dbus,
  libpng,
  openssl,
  icu,
  lua,
  curl,
}:

let
  # wesnoth requires lua built with c++, see https://github.com/wesnoth/wesnoth/pull/8234
  lua' = lua.override {
    postConfigure = ''
      makeFlagsArray+=("CC=$CXX")
    '';
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wesnoth";
  version = "1.18.7";

  src = fetchFromGitHub {
    owner = "wesnoth";
    repo = "wesnoth";
    tag = finalAttrs.version;
    hash = "sha256-fODkyn4tyWL3PUVjXS4d7OW7VnQSL+fPaytvS8iigXg=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  buildInputs = [
    sdl2-compat
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    pango
    gettext
    boost
    libvorbis
    fribidi
    dbus
    libpng
    openssl
    icu
    lua'
    curl
  ];

  cmakeEntries = {
    ENABLE_SYSTEM_LUA = true;
  };

  meta = {
    description = "Battle for Wesnoth, a free, turn-based strategy game with a fantasy theme";
    longDescription = ''
      The Battle for Wesnoth is a Free, turn-based tactical strategy
      game with a high fantasy theme, featuring both single-player, and
      online/hotseat multiplayer combat. Fight a desperate battle to
      reclaim the throne of Wesnoth, or take hand in any number of other
      adventures.
    '';
    homepage = "https://www.wesnoth.org/";
    changelog = "https://github.com/wesnoth/wesnoth/blob/${finalAttrs.version}/changelog.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "wesnoth";
  };
})
