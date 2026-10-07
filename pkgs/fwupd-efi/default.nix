{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  gnu-efi,
  python3,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwupd-efi";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = "fwupd-efi";
    rev = "${finalAttrs.version}";
    hash = "sha256-resmgi+t1YahXWxt1ZPgAXW3L0ejBclwcA8W8AS31is=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    python3Packages.pefile
  ];

  buildInputs = [
    gnu-efi
  ];

  postPatch = ''
    patchShebangs \
      efi/generate_binary.py \
      efi/generate_sbat.py
  '';

  mesonEntries = {
    efi-includedir = "${gnu-efi}/include/efi";
    efi-libdir = "${gnu-efi}/lib";
    efi-ldsdir = "${gnu-efi}/lib";
    efi_sbat_distro_id = "nixos";
    efi_sbat_distro_summary = "NixOS";
    efi_sbat_distro_pkgname = "${finalAttrs.pname}";
    efi_sbat_distro_version = "${finalAttrs.version}";
    efi_sbat_distro_url = "https://search.nixos.org/packages?channel=unstable&show=fwupd-efi&from=0&size=50&sort=relevance&query=fwupd-efi";
  };

  mesonFeatures = {
    genpeimg = false;
  };

  meta = {
    homepage = "https://fwupd.org/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
