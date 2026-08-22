{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fantasque-sans-mono";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${finalAttrs.version}/FantasqueSansMono-Normal.zip";
    stripRoot = false;
    hash = "sha256-MNXZoDPi24xXHXGVADH16a3vZmFhwX0Htz02+46hWFc=";
  };

  installPhase = ''
    runHook preInstall

    find . -iname '*.ttf' -exec install -m644 -D -t "$out/share/fonts/truetype" {} +
    find . -iname '*.otf' -exec install -m644 -D -t "$out/share/fonts/opentype" {} +

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "Font family with a great monospaced variant for programmers";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
