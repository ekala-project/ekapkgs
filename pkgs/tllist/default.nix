{
  stdenv,
  lib,
  fetchFromCodeberg,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tllist";
  version = "1.1.0";

  src = fetchFromCodeberg {
    owner = "dnkl";
    repo = "tllist";
    rev = finalAttrs.version;
    hash = "sha256-4WW0jGavdFO3LX9wtMPzz3Z1APCPgUQOktpmwAM0SQw=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
  ];

  mesonBuildType = "release";

  doCheck = true;

  meta = {
    homepage = "https://codeberg.org/dnkl/tllist";
    description = "C header file only implementation of a typed linked list";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
