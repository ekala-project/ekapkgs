{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gbenchmark,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ftxui";
  version = "7.0.3";

  src = fetchFromGitHub {
    owner = "ArthurSonzogni";
    repo = "ftxui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hKdmzraAgKwvOGQXpglD9lm0465j92AAn2MhS9ZM4jA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  checkInputs = [
    gtest
    gbenchmark
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  cmakeFlags = [
    (lib.cmakeBool "FTXUI_BUILD_EXAMPLES" false)
    (lib.cmakeBool "FTXUI_BUILD_DOCS" false)
    (lib.cmakeBool "FTXUI_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  meta = {
    homepage = "https://github.com/ArthurSonzogni/FTXUI";
    changelog = "https://github.com/ArthurSonzogni/FTXUI/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Functional Terminal User Interface library for C++";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
