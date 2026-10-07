{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pegtl";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = "PEGTL";
    rev = finalAttrs.version;
    hash = "sha256-eOwUwnyvQwMNHzISOwhxfh83ij36iGvoUK4g7ZmaRDI=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeEntries = {
    PEGTL_BUILD_TESTS = false;
    PEGTL_BUILD_EXAMPLES = false;
  };

  meta = {
    homepage = "https://github.com/taocpp/pegtl";
    description = "Parsing Expression Grammar Template Library";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
  };
})
