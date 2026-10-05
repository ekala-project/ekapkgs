{
  fetchFromGitHub,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfel";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "xboot";
    repo = "xfel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+p+gRM9dx+8o4RhuHH4LFYBa4MeMKRkhV9Dvteo2cd0=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "UDEV_RULES_DIR=$(out)/etc/udev/rules.d"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libusb1 ];
  meta = {
    description = "Tooling for working with the FEL mode on Allwinner SoCs";
    homepage = "https://github.com/xboot/xfel";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "xfel";
  };
})
