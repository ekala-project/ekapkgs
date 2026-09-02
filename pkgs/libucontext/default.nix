{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libucontext";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${finalAttrs.version}";
    hash = "sha256-asT0pV3s4L4zB2qtDJ+2XYxEP6agIEo1LtCuFeOjpRA=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];
  meta = {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    teams = [ ];
  };
})
