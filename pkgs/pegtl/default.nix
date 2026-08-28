{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pegtl";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "taocpp";
    repo = "PEGTL";
    rev = finalAttrs.version;
    hash = "sha256-28uXdkXGN4FFkWMfiF3ArJhcJhTklWn6CeCEl/wFqA8=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    "-DPEGTL_BUILD_TESTS=OFF"
    "-DPEGTL_BUILD_EXAMPLES=OFF"
  ];

  meta = {
    homepage = "https://github.com/taocpp/pegtl";
    description = "Parsing Expression Grammar Template Library";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
  };
})
