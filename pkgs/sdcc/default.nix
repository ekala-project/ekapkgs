{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoconf,
  bison,
  boost,
  flex,
  gputils,
  texinfo,
  zlib,
  withGputils ? false,
  excludePorts ? [ ],
}:

assert
  lib.subtractLists [
    "ds390"
    "ds400"
    "gbz80"
    "hc08"
    "mcs51"
    "pic14"
    "pic16"
    "r2k"
    "r3ka"
    "s08"
    "stm8"
    "tlcs90"
    "z80"
    "z180"
  ] excludePorts == [ ];
stdenv.mkDerivation (finalAttrs: {
  pname = "sdcc";
  version = "4.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/sdcc/sdcc-src-${finalAttrs.version}.tar.bz2";
    hash = "sha256-1QMEN/tDa7HZOo29v7RrqqYGEzGPT7P1hx1ygV0e7YA=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    bison
    flex
  ];

  buildInputs = [
    boost
    texinfo
    zlib
  ]
  ++ lib.optionals withGputils [
    gputils
  ];

  patches = [
    (fetchpatch {
      name = "sdcc-fix-aslink-elf-signature.patch";
      url = "https://src.fedoraproject.org/rpms/sdcc/raw/4a7c2a7e32369461eb451fc6f4d678a010135afc/f/sdcc-4.4.0-aslink.patch";
      hash = "sha256-xGilNetecPBj2VV3ebmln5BKqs3OoWFf6y2S3TBTHMQ=";
    })
  ];

  postPatch = ''
    if grep -q '\.PHONY:.*install' sim/ucsim/Makefile.in; then
      echo 'Upstream has added `.PHONY: install` rule; must remove `postPatch` from the Nix file.' >&2
      exit 1
    fi
    echo '.PHONY: install' >> sim/ucsim/Makefile.in
  '';

  configureFlags =
    let
      excludedPorts =
        excludePorts
        ++ (lib.optionals (!withGputils) [
          "pic14"
          "pic16"
        ]);
    in
    map (f: "--disable-${f}-port") excludedPorts;

  preConfigure = ''
    if test -n "''${dontStrip-}"; then
      export STRIP=none
    fi
  '';

  meta = {
    homepage = "https://sdcc.sourceforge.net/";
    description = "Small Device C Compiler";
    license = if withGputils then lib.licenses.unfreeRedistributable else lib.licenses.gpl2Plus;
    mainProgram = "sdcc";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
