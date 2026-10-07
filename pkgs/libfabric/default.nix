{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  libuuid,
  numactl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfabric";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "ofiwg";
    repo = "libfabric";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YDqCgRW+ZJSyf6+9aZebVEA5SAQHMwxofwuYkfGhT4M=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libuuid
    numactl
  ];

  configureFlags = [
    "--disable-psm2"
    "--enable-opx"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://ofiwg.github.io/libfabric/";
    description = "Open Fabric Interfaces";
    license = with lib.licenses; [
      gpl2
      bsd2
    ];
    platforms = lib.platforms.all;
  };
})
