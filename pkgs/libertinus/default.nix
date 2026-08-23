{
  lib,
  stdenvNoCC,
  fetchurl,
  zstd,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libertinus";
  version = "7.051";

  src = fetchurl {
    url = "https://github.com/alerque/libertinus/releases/download/v${version}/Libertinus-${version}.tar.zst";
    hash = "sha256-JQZ3ySnTd1owkTZDWUN5ryZKwu8oAQNaody+MLm+I6Y=";
  };

  nativeBuildInputs = [
    zstd
  ];

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/opentype/ static/OTF/*.otf
    install -Dm644 -t $out/share/fonts/truetype/ static/TTF/*.ttf 2>/dev/null || true
    install -Dm644 -t $out/share/fonts/woff2/ static/WOFF2/*.woff2 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    description = "Libertinus font family";
    homepage = "https://github.com/alerque/libertinus";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
