{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinygltf";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V4d4n1gBNcwiqBQlUn9q5h9+SAchELg4V3ih9WPEWbw=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  meta = {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
