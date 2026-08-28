{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fira-sans";
  version = "4.301";

  src = fetchzip {
    url = "https://carrois.com/downloads/Fira/Download_Folder_FiraSans_${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }.zip";
    hash = "sha256-WBt3oqPK7ACqMhilYkyFx9Ek2ugwdCDFZN+8HLRnGRs";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall
    rm -rf "__MACOSX"
    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
    find . -iname '*.otf' -exec install -m644 -D -t $out/share/fonts/opentype {} +
    find . -iname '*.ttf' -exec install -m644 -D -t $out/share/fonts/truetype {} + || true
    runHook postInstall
  '';

  meta = {
    homepage = "https://carrois.com/fira/";
    description = "Sans-serif font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.
    '';
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
