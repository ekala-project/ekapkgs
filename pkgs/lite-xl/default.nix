{
  fetchFromGitHub,
  freetype,
  lib,
  lua,
  meson,
  ninja,
  cmake,
  pcre2,
  pkg-config,
  sdl3,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lite-xl";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "lite-xl";
    repo = "lite-xl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9JpD7f5vOGhLW8dBjjYUI5PSaz/XWW5sIOZCAbKhxtE=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    cmake
    cmake.configurePhaseHook
  ];

  buildInputs = [
    freetype
    lua
    pcre2
    sdl3
  ];

  # Fix SDL3 static linking issue
  postPatch = ''
    substituteInPlace src/meson.build \
      --replace-fail "dependency('sdl3', static: true)" "dependency('sdl3', static: false)"
  '';

  mesonFlags = [
    "-Duse_system_lua=true"
  ];

  meta = {
    description = "Lightweight text editor written in Lua";
    homepage = "https://github.com/lite-xl/lite-xl";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "lite-xl";
  };
})
