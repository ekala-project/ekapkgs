{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnu-efi";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "ncroxon";
    repo = "gnu-efi";
    tag = finalAttrs.version;
    hash = "sha256-d0ndzFxhpxa6tqX9211y3mI4OFg7JZUvuCzGiPuhEAo=";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  postPatch = ''
    substituteInPlace Make.defaults \
      --replace "-Werror" ""
  '';

  meta = {
    description = "GNU EFI development toolchain";
    homepage = "https://github.com/ncroxon/gnu-efi";
    license = with lib.licenses; [
      bsd2
      bsd2Patent
      bsd3
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
