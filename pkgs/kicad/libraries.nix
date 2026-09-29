{
  lib,
  stdenv,
  cmake,
  libSrc,
  python3,
}:
let
  mkLib =
    name:
    stdenv.mkDerivation {
      pname = "kicad-${name}";
      version = builtins.substring 0 10 (libSrc name).rev;

      src = libSrc name;

      nativeBuildInputs = [
        cmake
        cmake.configurePhaseHook
      ]
      ++ lib.optionals (name == "symbols") [
        python3
      ];

      meta = {
        license = lib.licenses.cc-by-sa-40;
        platforms = lib.platforms.all;
      };
    };
in
{
  symbols = mkLib "symbols";
  templates = mkLib "templates";
  footprints = mkLib "footprints";
}
