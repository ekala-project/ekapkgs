{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "stix-otf";
  version = "1.1.1";

  src = fetchzip {
    url = "https://sources.debian.org/src/fonts-stix/1.1.1-4.1/STIXv${version}-word.zip";
    stripRoot = false;
    hash = "sha256-M3STue+RPHi8JgZZupV0dVLZYKBiFutbBOlanuKkD08=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
    find . -iname '*.otf' -exec install -m644 -D -t $out/share/fonts/opentype {} +
    find . -iname '*.ttf' -exec install -m644 -D -t $out/share/fonts/truetype {} + || true
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.stixfonts.org/";
    description = "Fonts for Scientific and Technical Information eXchange";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
