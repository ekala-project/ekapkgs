{
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  lv2,
  withGtk3 ? true,
  gtk3,
  withQt5 ? true,
  qt5,
  withX11 ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "suil";
  version = "0.10.20";

  src = fetchFromGitLab {
    owner = "lv2";
    repo = "suil";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rP8tq+zmHrAZeuNttakPPfraFXNvnwqbhtt+LtTNV/k=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "gtk2" false)
    (lib.mesonEnable "gtk3" withGtk3)
    (lib.mesonEnable "qt5" withQt5)
    (lib.mesonEnable "x11" withX11)
  ];

  buildInputs = [
    lv2
  ]
  ++ lib.optionals withGtk3 [ gtk3 ]
  ++ lib.optionals withQt5 (
    with qt5;
    [
      qtbase
      qttools
    ]
    ++ lib.optionals withX11 [ qtx11extras ]
  );

  dontWrapQtApps = true;

  strictDeps = true;

  meta = {
    homepage = "http://drobilla.net/software/suil";
    description = "Lightweight C library for loading and wrapping LV2 plugin UIs";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
