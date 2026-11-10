{
  mkKdeDerivation,
  pkg-config,
  qtwayland,
  qtmultimedia,
  opencv,
  tesseract,
}:
mkKdeDerivation {
  pname = "spectacle";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    # TODO: ekapkgs tesseract has no enableLanguages; add language data support
    tesseract
    qtwayland
    qtmultimedia
    # ekapkgs opencv has no enabledModules; spectacle only needs core and imgproc
    # https://invent.kde.org/graphics/spectacle/-/blob/master/CMakeLists.txt?ref_type=heads#L83
    opencv
  ];

  meta.mainProgram = "spectacle";
}
