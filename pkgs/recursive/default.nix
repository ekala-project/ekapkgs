{
  lib,
  fetchzip,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation rec {
  pname = "recursive";
  version = "1.085";

  src = fetchzip {
    url = "https://github.com/arrowtype/recursive/releases/download/v${version}/ArrowType-Recursive-${version}.zip";
    sha256 = "sha256-hnGnKnRoQN8vFStW8TjLrrTL1dWsthUEWxfaGF0b0vM=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -D -t $out/share/fonts/opentype/ $(find $src -type f -name '*.otf')
    install -D -t $out/share/fonts/truetype/ $(find $src -type f -name '*.ttf')

    runHook postInstall
  '';

  meta = {
    description = "Variable font family for code & UI";
    homepage = "https://recursive.design/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
