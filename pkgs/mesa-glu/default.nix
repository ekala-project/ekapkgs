{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  libGLX,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glu";
  version = "9.0.3";

  src = fetchurl {
    url = "https://mesa.freedesktop.org/archive/glu/glu-${finalAttrs.version}.tar.xz";
    hash = "sha256-vUP+EvN0sRkusV/iDkX/RWubwmq1fw7ukZ+Wyg+KMw8=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [ libGLX ];

  mesonEntries = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    gl_provider = "gl";
  };

  meta = {
    description = "OpenGL utility library";
    homepage = "https://cgit.freedesktop.org/mesa/glu/";
    license = lib.licenses.sgi-b-20;
    pkgConfigModules = [ "glu" ];
    platforms = lib.platforms.unix;
  };
})
