{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "atkinson-hyperlegible-mono";
  version = "2.001-unstable-2024-11-20";

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "atkinson-hyperlegible-next-mono";
    rev = "154d50362016cc3e873eb21d242cd0772384c8f9";
    hash = "sha256-V0zWbNYT3RGO9vjX+GHfO38ywMozcZVJkBZH+8G5sC0=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.otf' -exec install -Dm644 -t $out/share/fonts/opentype/ {} +
    find . -name '*.ttf' -exec install -Dm644 -t $out/share/fonts/truetype/ {} +
    find . -name '*.woff2' -exec install -Dm644 -t $out/share/fonts/woff2/ {} +

    runHook postInstall
  '';

  meta = {
    description = "New (2024) monospace sibling family to Atkinson Hyperlegible Next";
    homepage = "https://www.brailleinstitute.org/freefont/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
