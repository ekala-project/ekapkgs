{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  pulseaudio,
  alsa-lib,
  libcap,
}:

let
  libpulseaudio = pulseaudio.override { libOnly = true; };
in
stdenv.mkDerivation (finalAttrs: {
  version = "1.2.2";
  pname = "libao";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "libao";
    rev = finalAttrs.version;
    sha256 = "0svgk4sc9kdhcsfyvbvgm5vpbg3sfr6z5rliflrw49v3x2i4vxq5";
  };

  patches = [
    (fetchpatch {
      name = "nanosecond-header.patch";
      url = "https://github.com/xiph/libao/commit/1f998f5d6d77674dad01b181811638578ad68242.patch";
      hash = "sha256-cvlyhQq1YS4pVya44LfsKD1R6iSOONsHJGRbP5LlanQ=";
    })
  ];

  configureFlags = [
    "--disable-broken-oss"
    "--enable-alsa-mmap"
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libcap
    libpulseaudio
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://xiph.org/ao/";
    description = "Xiph.org's cross-platform audio output library";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
})
