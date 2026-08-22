{
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses ? null,
  perl ? null,
  pkg-config,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "liboping";
  version = "1.10.0";

  src = fetchurl {
    url = "https://noping.cc/files/liboping-${finalAttrs.version}.tar.bz2";
    hash = "sha256-6ziqk/k+irKC2X4lgvuuqIs/iJoIy8nb8gBZw3edXNg=";
  };

  patches = [
    ./ncurses-6.3.patch

    (fetchpatch {
      name = "format-args.patch";
      url = "https://github.com/octo/liboping/commit/7a50e33f2a686564aa43e4920141e6f64e042df1.patch";
      sha256 = "118fl3k84m3iqwfp49g5qil4lw1gcznzmyxnfna0h7za2nm50cxw";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    ncurses
    perl
  ];

  configureFlags = [
    "ac_cv_func_malloc_0_nonnull=yes"
  ]
  ++ lib.optional (perl == null) "--with-perl-bindings=no";

  buildFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "C library to generate ICMP echo requests (a.k.a. ping packets)";
    homepage = "https://noping.cc/";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
