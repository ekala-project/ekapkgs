{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  gtk3,
  alsa-lib,
  libpulseaudio,
  fftw,
  json_c,
  libjack2,
  jackSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lingot";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://savannah/lingot/lingot-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-xPl+SWo2ZscHhtE25vLMxeijgT6wjNo1ys1+sNFvTVY=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    alsa-lib
    libpulseaudio
    fftw
    fftw.float
    json_c
  ]
  ++ lib.optional jackSupport libjack2;

  configureFlags = lib.optional (!jackSupport) "--disable-jack";

  meta = {
    description = "Not a Guitar-Only tuner";
    mainProgram = "lingot";
    homepage = "https://www.nongnu.org/lingot/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
