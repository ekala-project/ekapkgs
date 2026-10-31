{
  lib,
  stdenv,
  frrSource,
  frrVersion,
  autoreconfHook,
  flex,
  bison,
  pkg-config,
  elfutils,
  perl,
  python3,
}:

stdenv.mkDerivation {
  pname = "frr-clippy-helper";
  version = frrVersion;

  src = frrSource;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    perl
    pkg-config
  ];

  buildInputs = [
    python3
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [
    elfutils
  ];

  configureFlags = [
    "--enable-clippy-only"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp lib/clippy $out/bin
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://frrouting.org/";
    description = "FRR routing daemon suite: CLI helper tool clippy";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = lib.platforms.unix;
  };
}
