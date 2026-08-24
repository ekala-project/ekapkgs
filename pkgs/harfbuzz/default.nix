{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  glib,
  freetype,
  meson,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "harfbuzz";
  version = "14.3.1";

  src = fetchurl {
    url = "https://github.com/harfbuzz/harfbuzz/releases/download/${finalAttrs.version}/harfbuzz-${finalAttrs.version}.tar.xz";
    hash = "sha256-na6VOKri/99wzsMfLCe/aOKq7q4xEmiEZ2l9X69hlPc=";
  };

  patches = [ ./disable-check-symbols-test.patch ];

  postPatch = ''
    patchShebangs src/*.py test
  '';

  outputs = [
    "out"
    "dev"
  ];
  outputBin = "dev";

  mesonBuildType = "release";
  mesonAutoFeatures = "disabled";

  mesonFlags = [
    (lib.mesonEnable "cairo" false)
    (lib.mesonEnable "raster" false)
    (lib.mesonEnable "chafa" false)
    (lib.mesonEnable "coretext" false)
    (lib.mesonEnable "graphite" false)
    (lib.mesonEnable "icu" false)
    (lib.mesonEnable "introspection" false)
    (lib.mesonEnable "glib" true)
    (lib.mesonEnable "freetype" true)
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "tests" false)
    (lib.mesonOption "cmakepackagedir" "${placeholder "dev"}/lib/cmake")
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    glib
  ];

  buildInputs = [
    glib
    freetype
  ];

  meta = {
    description = "OpenType text shaping engine";
    homepage = "https://harfbuzz.github.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
