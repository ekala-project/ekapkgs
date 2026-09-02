{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lv2";
  version = "1.18.10";

  src = fetchurl {
    url = "https://lv2plug.in/spec/lv2-${finalAttrs.version}.tar.xz";
    hash = "sha256-eMUbzyG1Tli7Yymsy7Ta4Dsu15tSD5oB5zS9neUwlT8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dplugins=disabled"
    "-Dtests=disabled"
    "-Ddocs=disabled"
  ];

  meta = {
    homepage = "https://lv2plug.in";
    description = "Plugin standard for audio systems";
    mainProgram = "lv2_validate";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
