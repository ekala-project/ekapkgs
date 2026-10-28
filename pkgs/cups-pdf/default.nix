{
  lib,
  stdenv,
  fetchurl,
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cups-pdf";
  version = "3.0.1";

  src = fetchurl {
    url = "https://www.cups-pdf.de/src/cups-pdf_${finalAttrs.version}.tar.gz";
    hash = "sha256-c4Zp7f9/FGn+XkESAth/k7oltF8zKmI/tgfUnFmqlTE=";
  };

  strictDeps = true;

  buildInputs = [ cups ];

  buildPhase = ''
    runHook preBuild

    cd src
    $CC -o cups-pdf cups-pdf.c -lcups

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 cups-pdf $out/lib/cups/backend/cups-pdf
    cd ..
    install -Dm644 extra/cups-pdf.conf $out/etc/cups/cups-pdf.conf
    install -Dm644 extra/CUPS-PDF_opt.ppd $out/share/cups/model/CUPS-PDF_opt.ppd

    runHook postInstall
  '';

  meta = {
    description = "CUPS backend for PDF virtual printer";
    homepage = "https://www.cups-pdf.de/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
