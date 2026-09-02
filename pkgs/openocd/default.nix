{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  hidapi,
  tcl,
  jimtcl,
  libjaylink,
  libusb1,
  libftdi1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openocd";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/openocd/openocd/${finalAttrs.version}/openocd-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-ryVHiL6Yhh8r2RA/5uYKd07Jaow3R0Tu+Rl/YEMHWvo=";
  };

  nativeBuildInputs = [
    pkg-config
    tcl
  ];

  buildInputs = [
    hidapi
    jimtcl
    libftdi1
    libjaylink
    libusb1
  ];

  configureFlags = [
    "--disable-werror"
    "--enable-jtag_vpi"
    "--enable-remote-bitbang"
    "--enable-buspirate"
    "--enable-ftdi"
    "--disable-linuxgpiod"
    "--enable-sysfsgpio"
  ];

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=cpp"
    "-Wno-error=strict-prototypes"
  ];

  postInstall = ''
    mkdir -p "$out/etc/udev/rules.d"
    rules="$out/share/openocd/contrib/60-openocd.rules"
    if [ ! -f "$rules" ]; then
        echo "$rules is missing, must update the Nix file."
        exit 1
    fi
    ln -s "$rules" "$out/etc/udev/rules.d/"
  '';

  meta = {
    description = "Free and Open On-Chip Debugging, In-System Programming and Boundary-Scan Testing";
    mainProgram = "openocd";
    homepage = "https://openocd.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
