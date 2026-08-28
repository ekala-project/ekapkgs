{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libqalculate ? null,
  gtk3,
  curl,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qalculate-gtk";
  version = "5.12.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-gtk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c0n0iu8KB0sK7dnvMcwQAFQvtOmaBpET4oRRufliN4k=";
  };

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    libqalculate
    gtk3
    curl
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    license = lib.licenses.gpl2Plus;
    mainProgram = "qalculate-gtk";
    platforms = lib.platforms.linux;
  };
})
