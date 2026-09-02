{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zix";
  version = "0.6.2";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "zix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1fdW014QKvTYHaEmDsivUVPzF/vZgnW3Srk6edp6G1o=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  mesonFlags = [
    "-Dbenchmarks=disabled"
    "-Ddocs=disabled"
    "-Dtests=disabled"
  ];

  meta = {
    description = "Lightweight C99 portability and data structure library";
    homepage = "https://gitlab.com/drobilla/zix";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
})
