{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btop";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "aristocratos";
    repo = "btop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3gECGBSWcGTYQkUlD4X2zrxZVvH2x2xfh5zdZ2jJbDQ=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  installFlags = [ "PREFIX=$(out)" ];

  cmakeFlags = [
    (lib.cmakeBool "BTOP_LTO" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "BTOP_STATIC" (stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BTOP_FORTIFY" (!stdenv.hostPlatform.isStatic))
  ];

  hardeningDisable = lib.optionals stdenv.hostPlatform.isStatic [ "fortify" ];

  postInstall = ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/bin/btop)
  '';

  meta = {
    description = "Monitor of resources";
    homepage = "https://github.com/aristocratos/btop";
    changelog = "https://github.com/aristocratos/btop/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "btop";
  };
})
