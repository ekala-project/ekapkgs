{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libimobiledevice,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "usbmuxd";
  version = "1.1.1+date=2023-05-05";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "usbmuxd";
    rev = "01c94c77f59404924f1c46d99c4e5e0c7817281b";
    hash = "sha256-WqbobkzlJ9g5fb9S2QPi3qdpCLx3pxtNlT7qDI63Zp4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  propagatedBuildInputs = [
    libimobiledevice
    libusb1
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${version}
  '';

  configureFlags = [
    "--with-udevrulesdir=${placeholder "out"}/lib/udev/rules.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  meta = {
    homepage = "https://github.com/libimobiledevice/usbmuxd";
    description = "Socket daemon to multiplex connections from and to iOS devices";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "usbmuxd";
  };
}
