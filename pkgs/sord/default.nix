{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pcre2,
  pkg-config,
  serd,
  zix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sord";
  version = "0.16.20";

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "sord";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+f3dxhcxVoub+KeI5c5/J87SVvAawrm5cZgo2qogdRM=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [ pcre2 ];

  propagatedBuildInputs = [
    serd
    zix
  ];

  mesonFlags = [
    "-Ddocs=disabled"
    "-Dtests=disabled"
  ];

  meta = {
    homepage = "http://drobilla.net/software/sord";
    description = "Lightweight C library for storing RDF data in memory";
    license = with lib.licenses; [
      bsd0
      isc
    ];
    platforms = lib.platforms.unix;
  };
})
