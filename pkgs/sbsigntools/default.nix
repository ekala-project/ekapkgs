{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  openssl,
  gnu-efi,
  help2man,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sbsigntools";
  version = "0.9.5";

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git/snapshot/sbsigntools-${finalAttrs.version}.tar.gz";
    hash = "sha256-ojI+VL5tF/UM6zJTym7QYxcaW8tweb+llACM0q63/eo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    help2man
    pkg-config
  ];

  buildInputs = [
    gnu-efi
    openssl
    util-linux
  ];

  preConfigure = "touch AUTHORS NEWS";

  meta = {
    description = "Tools for signing UEFI Secure Boot binaries";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/jejb/sbsigntools.git";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "sbsign";
  };
})
