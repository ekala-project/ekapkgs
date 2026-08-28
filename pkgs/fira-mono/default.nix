{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fira-mono";
  version = "3.2";

  src = fetchzip {
    url = "https://carrois.com/downloads/Fira/Fira_Mono_${
      lib.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }.zip";
    hash = "sha256-Ukc+K2sdSz+vUQFD8mmwJHZQ3N68oM4fk6YzGLwzAfQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
    find . -iname '*.otf' -exec install -m644 -D -t $out/share/fonts/opentype {} +
    find . -iname '*.ttf' -exec install -m644 -D -t $out/share/fonts/truetype {} + || true
    runHook postInstall
  '';

  meta = {
    homepage = "https://carrois.com/fira/";
    description = "Monospace font for Firefox OS";
    longDescription = ''
      Fira Mono is a monospace font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS. Available in Regular,
      Medium, and Bold.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
