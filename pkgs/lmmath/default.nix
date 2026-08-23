{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "lmmath";
  version = "1.959";

  src = fetchzip {
    url = "https://www.gust.org.pl/projects/e-foundry/lm-math/download/latinmodern-math-1959.zip";
    hash = "sha256-et/WMhfZZYgP0S7ZmI6MZK5owv9bSoMBXFX6yGSng5Y=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.otf' -exec install -Dm644 -t $out/share/fonts/opentype/ {} +

    runHook postInstall
  '';

  meta = {
    description = "Latin Modern Math (LM Math) font completes the modernization of the Computer Modern family of typefaces designed and programmed by Donald E. Knuth";
    homepage = "https://www.gust.org.pl/projects/e-foundry/lm-math";
    license = lib.licenses.lppl13c;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
