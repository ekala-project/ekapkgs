{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "inconsolata";
  version = "3.001";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "0f203e3740b5eb77e0b179dff1e5869482676782";
    hash = "sha256-aDsKxtbEgGbtABHWqeNCf67BmIgewaMRaksoLOZQ67c=";
    rootDir = "ofl/inconsolata";
  };

  installPhase = ''
    runHook preInstall
    install -m644 --target $out/share/fonts/truetype/inconsolata -D ofl/inconsolata/static/*.ttf ofl/inconsolata/*.ttf
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "Monospace font for both screen and print";
    maintainers = [ ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
