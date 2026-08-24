{ lib
, stdenvNoCC
, fetchzip
,
}:

stdenvNoCC.mkDerivation {
  pname = "undefined-medium";
  version = "1.3";

  src = fetchzip {
    url = "https://github.com/andirueckel/undefined-medium/archive/v1.3.zip";
    hash = "sha256-cVdk6a0xijAQ/18W5jalqRS7IiPufMJW27Scns+nbEY=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = {
    homepage = "https://undefined-medium.com/";
    description = "Pixel grid-based monospace typeface";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
