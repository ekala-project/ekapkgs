{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  freetype,
  ftgl,
  libjack2,
  libX11,
  lv2,
  libGLU,
  libGL,
  pkg-config,
  ttf_bitstream_vera,
}:

stdenv.mkDerivation {
  pname = "setbfree";
  version = "0.8.15";

  src = fetchFromGitHub {
    owner = "pantherb";
    repo = "setBfree";
    rev = "v0.8.15";
    hash = "sha256-bF7/M7VQF5OedeDHWO0TssDP1caeOVdbrKHX9KbwlC0=";
  };

  postPatch = ''
    substituteInPlace common.mak \
      --replace /usr/local "$out" \
      --replace /usr/share/fonts/truetype/ttf-bitstream-vera "${ttf_bitstream_vera}/share/fonts/truetype"
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    freetype
    ftgl
    libjack2
    libX11
    lv2
    libGLU
    libGL
    ttf_bitstream_vera
  ];

  meta = {
    description = "Digital tonewheel organ emulator";
    homepage = "https://setbfree.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
