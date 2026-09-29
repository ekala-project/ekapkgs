{
  qtModule,
  bluez,
  libevdev,
  libx11,
  pkg-config,
  qtbase,
  udev,
  wrapQtAppsHook,
}:

qtModule {
  pname = "qtsystems";

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  propagatedBuildInputs = [
    qtbase
  ];

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    bluez
    libevdev
    libx11
    udev
  ];

  qmakeFlags = [
    "CONFIG+=git_build"
    "CONFIG+=ofono"
    "CONFIG+=udisks"
    "CONFIG+=upower"
  ];

  postFixup = ''
    wrapQtApp $bin/bin/servicefw
  '';
}
