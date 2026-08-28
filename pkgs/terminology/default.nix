{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  efl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "terminology";
  version = "1.14.0";

  src = fetchurl {
    url = "https://download.enlightenment.org/rel/apps/terminology/terminology-${finalAttrs.version}.tar.xz";
    hash = "sha256-81QFcFGwXP+2meM4NqETXbHU7Yv5VPm1fcDpO8MHUU0=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    efl
  ];

  mesonBuildType = "release";

  postPatch = ''
    patchShebangs data/colorschemes/*.py
  '';

  meta = {
    description = "Powerful terminal emulator based on EFL";
    homepage = "https://www.enlightenment.org/about-terminology";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
