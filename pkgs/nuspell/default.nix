{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  icu,
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nuspell";
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "nuspell";
    repo = "nuspell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-39lj/44rnMWDzCVLY1LMuutCVL7Y0+7CSl7zydUF1cU=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
  ];

  strictDeps = true;

  buildInputs = [ catch2_3 ];

  propagatedBuildInputs = [ icu ];

  cmakeFlags = [ "-DBUILD_DOCS=OFF" ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  meta = {
    description = "Free and open source C++ spell checking library";
    mainProgram = "nuspell";
    homepage = "https://nuspell.github.io/";
    platforms = lib.platforms.all;
    license = lib.licenses.lgpl3Plus;
    changelog = "https://github.com/nuspell/nuspell/blob/v${finalAttrs.version}/CHANGELOG.md";
  };
})
