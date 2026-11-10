{
  mkKdeDerivation,
}:
mkKdeDerivation {
  pname = "oxygen";

  # The Qt5 style needs KDE Frameworks 5, which ekapkgs doesn't package.
  cmakeEntries.BUILD_QT5 = false;
}
