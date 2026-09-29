{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidfuzz-cpp";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "rapidfuzz";
    repo = "rapidfuzz-cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uyOkp+a08V+4Hvwp1OY6XMMd37z5RI+W5G4URu6FQtU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = lib.optionals finalAttrs.finalPackage.doCheck [
    "-DRAPIDFUZZ_BUILD_TESTING=ON"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    CXXFLAGS = toString [
      "-include"
      "algorithm"
    ];
  };

  nativeCheckInputs = [
    catch2_3
  ];

  meta = {
    description = "Rapid fuzzy string matching in C++ using the Levenshtein Distance";
    homepage = "https://github.com/rapidfuzz/rapidfuzz-cpp";
    changelog = "https://github.com/rapidfuzz/rapidfuzz-cpp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
