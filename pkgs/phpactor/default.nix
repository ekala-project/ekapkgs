# phpactor — PHP language server
{
  lib,
  stdenv,
  fetchurl,
  php,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phpactor";
  version = "2026.07.22.0";

  src = fetchurl {
    url = "https://github.com/phpactor/phpactor/releases/download/${finalAttrs.version}/phpactor.phar";
    hash = "sha256-jAFVOAuddVmhLzXd+NCcHcI+cvF5dJgDglH8Na0VV00=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    install -m644 $src $out/lib/phpactor.phar
    makeWrapper ${php}/bin/php $out/bin/phpactor \
      --add-flags "$out/lib/phpactor.phar"
    runHook postInstall
  '';

  meta = {
    description = "PHP language server and refactoring tool";
    homepage = "https://phpactor.readthedocs.io/";
    license = lib.licenses.mit;
    mainProgram = "phpactor";
  };
})
