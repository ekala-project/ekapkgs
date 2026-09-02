{
  lib,
  stdenv,
  fetchurl,
  flex,
  libusb1,
  meson,
  ninja,
  pcsclite,
  perl,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.6.2";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.xz";
    hash = "sha256-QZWEEJUBV+Yi+dkcnnjHtwjbdOIvcRkMWB0k0gVk1Ek=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace meson.build --replace-fail \
      "pcsc_dep.get_variable('usbdropdir')" \
      "'$out/pcsc/drivers'"
  '';

  mesonFlags = [
    (lib.mesonBool "serial" true)
  ];

  nativeBuildInputs = [
    flex
    perl
    pkg-config
    meson
    meson.configurePhaseHook
    ninja
  ];

  buildInputs = [
    libusb1
    pcsclite
    zlib
  ];

  postInstall = ''
    install -Dm 0444 -t $out/lib/udev/rules.d ../src/92_pcscd_ccid.rules
    substituteInPlace $out/lib/udev/rules.d/92_pcscd_ccid.rules \
      --replace-fail "/usr/sbin/pcscd" "${pcsclite}/bin/pcscd"
  '';

  # The resulting shared object ends up outside of the default paths which are
  # usually getting stripped.
  stripDebugList = [ "pcsc" ];

  meta = {
    description = "PC/SC driver for USB CCID smart card readers";
    homepage = "https://ccid.apdu.fr/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
  };
}
