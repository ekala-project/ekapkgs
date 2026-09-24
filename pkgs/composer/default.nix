# composer — PHP dependency manager
{
  lib,
  stdenv,
  fetchurl,
  php,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "composer";
  version = "2.8.8";

  src = fetchurl {
    url = "https://getcomposer.org/download/${finalAttrs.version}/composer.phar";
    hash = "sha256-lXJj4oS596E9f0ddxl82FNFRsMTcx+h2H35/dJRH+2g=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    install -m644 $src $out/lib/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/lib/composer.phar"
    runHook postInstall
  '';

  meta = {
    description = "Dependency manager for PHP";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
  };
})
