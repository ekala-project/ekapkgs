{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uriparser";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "uriparser";
    repo = "uriparser";
    tag = "uriparser-${finalAttrs.version}";
    hash = "sha256-BM2Nf7iKlS336RG7f+ZKBm/+yru5wB9p2TVdY7kYgKg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "URIPARSER_BUILD_DOCS" false)
    (lib.cmakeBool "URIPARSER_BUILD_TESTS" false)
  ];

  meta = {
    description = "Strictly RFC 3986 compliant URI parsing library";
    homepage = "https://uriparser.github.io/";
    license = lib.licenses.bsd3;
    mainProgram = "uriparse";
    platforms = lib.platforms.unix;
  };
})
