{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "urw-base35-fonts";
  version = "20200910";

  src = fetchFromGitHub {
    owner = "ArtifexSoftware";
    repo = "urw-base35-fonts";
    tag = version;
    hash = "sha256-YQl5IDtodcbTV3D6vtJi7CwxVtHHl58fG6qCAoSaP4U=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/{opentype,truetype}
    install -m 444 fonts/*.otf $out/share/fonts/opentype/
    install -m 444 fonts/*.ttf $out/share/fonts/truetype/ 2>/dev/null || true

    mkdir -p $out/share/fontconfig/conf.avail
    install -m 444 fontconfig/*.conf $out/share/fontconfig/conf.avail/ 2>/dev/null || true

    runHook postInstall
  '';

  meta = {
    description = "(URW)++ base 35 font set";
    homepage = "https://github.com/ArtifexSoftware/urw-base35-fonts";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
  };
}
