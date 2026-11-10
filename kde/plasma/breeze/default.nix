{
  mkKdeDerivation,
  qtsvg,
}:
mkKdeDerivation {
  pname = "breeze";

  outputs = [
    "out"
    "dev"
  ];

  extraBuildInputs = [ qtsvg ];

  # The Qt5 style needs KDE Frameworks 5, which ekapkgs doesn't package.
  cmakeEntries.BUILD_QT5 = false;

  meta.mainProgram = "breeze-settings6";
}
