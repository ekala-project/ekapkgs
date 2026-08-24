{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland-scanner,
  aml,
  jansson,
  libdrm,
  libxkbcommon,
  libgbm,
  neatvnc,
  pam,
  pixman,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayvnc";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = "wayvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XVu+sj7O6usFXljkGvQHU9KARjW9jYhFltgbY900TyA=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    aml
    jansson
    libdrm
    libxkbcommon
    libgbm
    neatvnc
    pam
    pixman
    wayland
  ];

  mesonFlags = [
    (lib.mesonBool "tests" false)
  ];

  meta = {
    description = "VNC server for wlroots based Wayland compositors";
    homepage = "https://github.com/any1/wayvnc";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "wayvnc";
    maintainers = [ ];
  };
})
