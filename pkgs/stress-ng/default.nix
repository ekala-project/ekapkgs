{
  lib,
  stdenv,
  fetchFromGitHub,
  attr,
  keyutils,
  libaio,
  libapparmor,
  libbsd,
  libcap,
  libgcrypt,
  lksctp-tools,
  zlib,
  libglvnd,
  libgbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stress-ng";
  version = "0.22.00";

  src = fetchFromGitHub {
    owner = "ColinIanKing";
    repo = "stress-ng";
    tag = "V${finalAttrs.version}";
    hash = "sha256-A0I/kU7pmr2ppoHl+4JN2ayuShFyWN5cv/ZZmZy6Hts=";
  };

  postPatch = ''
    sed -i '/\#include <bsd\/string.h>/i #undef HAVE_STRLCAT\n#undef HAVE_STRLCPY' stress-ng.h
  '';

  buildInputs = [
    libbsd
    libgcrypt
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    attr
    keyutils
    libaio
    libapparmor
    libcap
    lksctp-tools
    libglvnd
    libgbm
  ];

  makeFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "MANDIR=${placeholder "out"}/share/man/man1"
    "JOBDIR=${placeholder "out"}/share/stress-ng/example-jobs"
    "BASHDIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isMusl "-D_LINUX_SYSINFO_H=1";

  enableParallelBuilding = (!stdenv.hostPlatform.isi686);

  meta = {
    description = "Stress test a computer system";
    homepage = "https://github.com/ColinIanKing/stress-ng";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "stress-ng";
  };
})
