{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  doxygen,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iniparser";
  version = "4.2.6";

  src = fetchFromGitLab {
    owner = "iniparser";
    repo = "iniparser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z10S9ODLprd7CbL5Ecgh7H4eOwTetYwFXiWBUm6fIr4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    validatePkgConfig
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
  ];

  doCheck = false;

  postFixup = ''
    ln -sv $out/include/iniparser/*.h $out/include/
  '';

  strictDeps = true;

  meta = {
    homepage = "https://gitlab.com/iniparser/iniparser";
    description = "Free standalone ini file parsing library";
    changelog = "https://gitlab.com/iniparser/iniparser/-/releases/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "iniparser" ];
  };
})
