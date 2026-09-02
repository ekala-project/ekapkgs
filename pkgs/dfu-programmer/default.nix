{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libusb1,

}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dfu-programmer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dfu-programmer";
    repo = "dfu-programmer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YhiBD8rpzEVVaP3Rdfq74lhZ0Mu7OEbrMsM3fBL1Kvk";
  };

  buildInputs = [
    libusb1
  ];

  nativeBuildInputs = [
    autoreconfHook
  ];

  # No build configured in source, automake requires ChangeLog to exist
  preAutoreconf = ''
    touch ChangeLog
  '';

  postPatch = ''
    patchShebangs --build bootstrap.sh
    patchShebangs --build update-bash-completion.sh
  '';
  meta = {
    license = lib.licenses.gpl2;
    description = "Device Firmware Update based USB programmer for Atmel chips with a USB bootloader";
    mainProgram = "dfu-programmer";
    homepage = "https://github.com/dfu-programmer/dfu-programmer";
    platforms = lib.platforms.unix;
  };
})
