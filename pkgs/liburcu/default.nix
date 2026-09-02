{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "0.15.6";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${finalAttrs.version}.tar.bz2";
    hash = "sha256-hQsZIJbrEevyxw6Pl7x9p0ee5B2hvr60TjmGkIusQU8=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeCheckInputs = [ perl ];

  enableParallelBuilding = true;

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.intersectLists lib.platforms.unix (
      lib.platforms.x86
      ++ lib.platforms.power
      ++ lib.platforms.s390
      ++ lib.platforms.arm
      ++ lib.platforms.aarch64
      ++ lib.platforms.mips
      ++ lib.platforms.m68k
      ++ lib.platforms.riscv
      ++ lib.platforms.loongarch64
    );
  };
})
