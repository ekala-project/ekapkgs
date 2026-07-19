{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  meson,
  ninja,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtsm";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "libtsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CN5ktki8fbvmiGiyDvDf4ayRKakpWRI51SdhRbFqNVM=";
  };

  strictDeps = true;

  buildInputs = [
    libxkbcommon
    check
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    changelog = "https://github.com/kmscon/libtsm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
