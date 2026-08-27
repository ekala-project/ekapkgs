{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  meson,
  ninja,
  pkg-config,
  doctest,
  glm,
  libevdev,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-config";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-config";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hZcmnteB8/DbKjQGY1QLSI32z+OBnp1b8RjJ8pPH1JY=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    libevdev
    libxml2
  ];

  propagatedBuildInputs = [
    glm
  ];

  strictDeps = true;

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonEnable "tests" false)
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wf-config";
    description = "Library for managing configuration files, written for Wayfire";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
