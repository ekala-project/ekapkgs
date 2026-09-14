{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "nerd-fonts-jetbrains-mono";
  version = "3.5.0";

  src = fetchurl {
    url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/JetBrainsMono.tar.xz";
    hash = "sha256-AieyIDYKb4Gbnq2SND6BErNHMwVHglYa9Qz7oeivq2M=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    dst_opentype=$out/share/fonts/opentype/NerdFonts/JetBrainsMono
    dst_truetype=$out/share/fonts/truetype/NerdFonts/JetBrainsMono

    find -name \*.otf -exec mkdir -p $dst_opentype \; -exec cp -p {} $dst_opentype \;
    find -name \*.ttf -exec mkdir -p $dst_truetype \; -exec cp -p {} $dst_truetype \;

    runHook postInstall
  '';

  meta = {
    description = "Nerd Fonts: JetBrains Mono with Nerd Font glyphs";
    license = with lib.licenses; [
      ofl
      mit
    ];
    homepage = "https://nerdfonts.com/";
    changelog = "https://github.com/ryanoasis/nerd-fonts/blob/v${version}/changelog.md";
    platforms = lib.platforms.all;
  };
}
