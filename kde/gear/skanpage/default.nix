{
  mkKdeDerivation,
  qtwebengine,
  tesseract,
  leptonica,
}:
mkKdeDerivation {
  pname = "skanpage";

  extraBuildInputs = [
    qtwebengine
    # TODO: ekapkgs tesseract has no enableLanguages; add language data support
    tesseract
    leptonica
  ];
  meta.mainProgram = "skanpage";
}
