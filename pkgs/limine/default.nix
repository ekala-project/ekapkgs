{
  fetchurl,
  lib,
  llvmPackages,
  mtools,
  nasm,
  enableAll ? false,
  buildCDs ? false,
  targets ? [ ],
  biosSupport ? true,
  pxeSupport ? false,
}:
let
  stdenv = llvmPackages.stdenv;

  hasX86 =
    (if targets == [ ] then stdenv.hostPlatform.isx86_32 else (builtins.elem "i686" targets))
    || (if targets == [ ] then stdenv.hostPlatform.isx86_64 else (builtins.elem "x86_64" targets))
    || enableAll;

  missingZerocallusedregs =
    (
      if targets == [ ] then stdenv.hostPlatform.isLoongArch64 else (builtins.elem "loongarch64" targets)
    )
    || (if targets == [ ] then stdenv.hostPlatform.isRiscV64 else (builtins.elem "riscv64" targets))
    || enableAll;

  biosSupport' = biosSupport && hasX86;
  pxeSupport' = pxeSupport && hasX86;

  uefiFlags =
    target:
    {
      aarch64 = [ "--enable-uefi-aarch64" ];
      i686 = [ "--enable-uefi-ia32" ];
      loongarch64 = [ "--enable-uefi-loongarch64" ];
      riscv64 = [ "--enable-uefi-riscv64" ];
      x86_64 = [ "--enable-uefi-x86-64" ];
    }
    .${target} or (throw "Unsupported target ${target}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "limine";
  version = "12.6.0";

  src = fetchurl {
    url = "https://github.com/Limine-Bootloader/Limine/releases/download/v${finalAttrs.version}/limine-${finalAttrs.version}.tar.gz";
    hash = "sha256-MXe4pkKXZno3n+s69kBbE8U2QJzkbXEuoSM+ntH4e5o=";
  };

  enableParallelBuilding = true;

  hardeningDisable = lib.optionals missingZerocallusedregs [
    "zerocallusedregs"
  ];

  nativeBuildInputs =
    [
      llvmPackages.libllvm
      llvmPackages.lld
    ]
    ++ lib.optionals (enableAll || buildCDs) [
      mtools
    ]
    ++ lib.optionals hasX86 [ nasm ];

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  configureFlags =
    lib.optionals enableAll [ "--enable-all" ]
    ++ lib.optionals biosSupport' [ "--enable-bios" ]
    ++ lib.optionals (buildCDs && biosSupport') [ "--enable-bios-cd" ]
    ++ lib.optionals buildCDs [ "--enable-uefi-cd" ]
    ++ lib.optionals pxeSupport' [ "--enable-bios-pxe" ]
    ++ lib.concatMap uefiFlags (
      if targets == [ ] then [ stdenv.hostPlatform.parsed.cpu.name ] else targets
    );

  meta = {
    homepage = "https://limine-bootloader.org/";
    changelog = "https://github.com/Limine-Bootloader/Limine/raw/refs/tags/v${finalAttrs.version}/ChangeLog";
    description = "Limine Bootloader";
    mainProgram = "limine";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      asl20
      bsd0
      bsd2
      bsd3
      mit
    ];
  };
})
