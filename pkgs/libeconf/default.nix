{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libeconf";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "libeconf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FyEy65moNWG3djq5Tp4ZCZDqlwQH5yY9jQEJGEEe8bo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  meta = {
    description = "Enhanced config file parser, which merges config files placed in several locations into one";
    homepage = "https://github.com/openSUSE/libeconf";
    changelog = "https://github.com/openSUSE/libeconf/blob/${finalAttrs.src.tag}/NEWS";
    license = lib.licenses.mit;
    mainProgram = "econftool";
    platforms = lib.platforms.all;
  };
})
