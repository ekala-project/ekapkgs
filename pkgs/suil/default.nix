{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  lv2,
  gtk2,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "suil";
  version = "0.10.20";

  src = fetchFromGitLab {
    owner = "lv2";
    repo = "suil";
    rev = "v${version}";
    hash = "sha256-rP8tq+zmHrAZeuNttakPPfraFXNvnwqbhtt+LtTNV/k=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    lv2
    gtk2
    gtk3
  ];

  mesonFlags = [
    (lib.mesonEnable "gtk2" true)
    (lib.mesonEnable "gtk3" true)
    (lib.mesonEnable "qt5" false)
    (lib.mesonEnable "x11" true)
    (lib.mesonEnable "docs" false)
  ];

  strictDeps = true;

  meta = {
    homepage = "http://drobilla.net/software/suil";
    description = "Lightweight C library for loading and wrapping LV2 plugin UIs";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
