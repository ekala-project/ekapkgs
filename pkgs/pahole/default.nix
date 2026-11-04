{
  lib,
  stdenv,
  fetchzip,
  pkg-config,
  libbpf,
  cmake,
  ninja,
  elfutils,
  zlib,
  argp-standalone,
  musl-obstack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pahole";
  version = "1.32";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/snapshot/pahole-${finalAttrs.version}.tar.gz";
    hash = "sha256-+vydbVzkM+VUROo3Zo+XJeJMkvwtwEIS/4GgxmqvAZE=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
  ];

  buildInputs = [
    elfutils
    zlib
    libbpf
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    argp-standalone
    musl-obstack
  ];

  cmakeEntries = {
    CMAKE_INSTALL_LIBDIR = "lib";
    LIBBPF_EMBEDDED = false;
  };

  meta = {
    homepage = "https://git.kernel.org/pub/scm/devel/pahole/pahole.git/";
    description = "Shows, manipulates, and pretty-prints debugging information in DWARF, CTF, and BTF formats";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "pahole";
  };
})
