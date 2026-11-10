{
  mkKdeDerivation,
  qtwayland,
  libxcursor,
}:
mkKdeDerivation {
  pname = "plasma-integration";

  # force it to check our custom import path too
  patches = [ ./qml-path.patch ];

  # The Qt5 platform theme needs KDE Frameworks 5, which ekapkgs doesn't
  # package.
  cmakeEntries.BUILD_QT5 = false;

  extraBuildInputs = [
    qtwayland
    libxcursor
  ];
}
