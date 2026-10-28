{
  enableGUI ? true,
  enablePDFtoPPM ? true,
  enablePrinting ? true,
  lib,
  stdenv,
  fetchzip,
  cmake,
  makeDesktopItem,
  zlib,
  libpng,
  cups ? null,
  freetype ? null,
  qtbase ? null,
  qtsvg ? null,
  qt5,
}:

assert enableGUI -> qtbase != null && qtsvg != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert enablePrinting -> cups != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "xpdf";
  version = "4.06";

  src = fetchzip {
    urls = [
      "https://dl.xpdfreader.com/xpdf-${finalAttrs.version}.tar.gz"
      "https://dl.xpdfreader.com/old/xpdf-${finalAttrs.version}.tar.gz"
    ];
    hash = "sha256-n8Qeb1OKELzkjK+wqWlKbjt2XVX/+6hfbbFvw3EzS1w=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt --replace \
        'cmake_minimum_required(VERSION 2.8.12)' 'cmake_minimum_required(VERSION 3.1.0)'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ]
  ++ lib.optional enableGUI qt5.wrapQtAppsHook;

  cmakeEntries = {
    SYSTEM_XPDFRC = "/etc/xpdfrc";
    A4_PAPER = true;
    OPI_SUPPORT = true;
  }
  // lib.optionalAttrs (!enablePrinting) {
    XPDFWIDGET_PRINTING = false;
  };

  buildInputs = [
    zlib
    libpng
  ]
  ++ lib.optional enableGUI qtbase
  ++ lib.optional enablePrinting cups
  ++ lib.optional enablePDFtoPPM freetype;

  desktopItem = makeDesktopItem {
    name = "xpdf";
    desktopName = "Xpdf";
    comment = "Views Adobe PDF files";
    icon = "xpdf";
    exec = "xpdf %f";
    categories = [ "Office" ];
  };

  postInstall = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -Dm644 ${finalAttrs.desktopItem}/share/applications/xpdf.desktop -t $out/share/applications
    install -Dm644 $src/xpdf-qt/xpdf-icon.svg $out/share/pixmaps/xpdf.svg
  '';

  meta = {
    homepage = "https://www.xpdfreader.com";
    description = "Viewer for Portable Document Format (PDF) files";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
    ];
    platforms = lib.platforms.unix;
  };
})
