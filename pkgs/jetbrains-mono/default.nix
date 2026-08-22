{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "jetbrains-mono";
  version = "2.304";

  src = fetchFromGitHub {
    owner = "jetbrains";
    repo = "jetbrainsmono";
    rev = "v${version}";
    hash = "sha256-SW9d5yVud2BWUJpDOlqYn1E1cqicIHdSZjbXjqOAQGw=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t "$out/share/fonts/opentype/" fonts/otf/*.otf
    install -Dm644 -t "$out/share/fonts/truetype/" fonts/ttf/*.ttf
    install -Dm644 -t "$out/share/fonts/truetype/" fonts/variable/*.ttf
    install -Dm644 -t "$out/share/fonts/WOFF2/" fonts/webfonts/*.woff2
    runHook postInstall
  '';

  meta = {
    description = "Typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    changelog = "https://github.com/JetBrains/JetBrainsMono/blob/v${version}/Changelog.md";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
