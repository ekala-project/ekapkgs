{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hunspell-dict-fr";
  version = "7.7";

  src = fetchurl {
    url = "https://grammalecte.net/dic/hunspell-french-dictionaries-v${finalAttrs.version}.zip";
    hash = "sha256-RDFNmS+UtGWMMahu8jUXJKQwZ1MbCvNkP5G/AiDu5hY=";
  };

  strictDeps = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 fr-classique.dic $out/share/hunspell/fr_FR.dic
    install -Dm644 fr-classique.aff $out/share/hunspell/fr_FR.aff

    runHook postInstall
  '';

  meta = {
    description = "Hunspell dictionary for French";
    homepage = "https://grammalecte.net/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
  };
})
