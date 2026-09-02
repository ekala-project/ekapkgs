{
  bzip2,
  cabextract ? null,
  dmg2img ? null,
  dtc,
  dumpifs ? null,
  fetchFromGitHub,
  fontconfig,
  gnutar,
  jefferson ? null,
  lib,
  lzfse ? null,
  lzo,
  lzop ? null,
  lz4,
  openssl,
  pkg-config,
  python3,
  rustPlatform,
  sasquatch ? null,
  sleuthkit ? null,
  srec2bin ? null,
  stdenv,
  ubi_reader ? null,
  ucl,
  uefi-firmware-parser ? null,
  unyaffs ? null,
  unzip,
  vmlinux-to-elf ? null,
  xz,
  zlib,
  zstd,
  p7zip ? null,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "binwalk";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-em+jOnhCZH5EEJrhXTHmxiwpMcBr5oNU1+5IJ1H/oco=";
  };

  cargoHash = "sha256-cnJVeuvNNApEHqgZDcSgqkH3DKAr8+HkqXUH9defTCA=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    bzip2
    dtc
    fontconfig
    lzo
    openssl
    python3.pkgs.python-lzo
    ucl
    unzip
    xz
    zlib
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    "--skip=binwalk::Binwalk"
    "--skip=binwalk::Binwalk::scan"
    "--skip=binwalk::Binwalk::analyze"
    "--skip=binwalk::Binwalk::extract"
  ];

  postInstall = ''
    wrapProgram $out/bin/binwalk --suffix PATH : ${
      lib.makeBinPath (
        lib.filter (x: x != null) [
          p7zip
          cabextract
          dmg2img
          dumpifs
          jefferson
          vmlinux-to-elf
          lz4
          lzfse
          lzop
          sasquatch
          srec2bin
          gnutar
          sleuthkit
          ubi_reader
          uefi-firmware-parser
          unyaffs
          zstd
        ]
      )
    }
  '';

  meta = {
    description = "Firmware Analysis Tool";
    homepage = "https://github.com/ReFirmLabs/binwalk";
    changelog = "https://github.com/ReFirmLabs/binwalk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "binwalk";
  };
})
