{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gettext,
  makeWrapper,
  alsa-lib,
  libjack2,
  tk,
  fftw,
  portaudio,
  portmidi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "puredata";
  version = "0.55-2";

  src = fetchurl {
    url = "http://msp.ucsd.edu/Software/pd-${finalAttrs.version}.src.tar.gz";
    hash = "sha256-EIKX+NHdGQ346LtKSsNIeSrM9wT5ogUtk8uoybi7Wls=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    makeWrapper
  ];

  buildInputs = [
    fftw
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  configureFlags = [
    "--enable-fftw"
    "--enable-jack"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-alsa"
  ];

  postInstall = ''
    wrapProgram $out/bin/pd --prefix PATH : ${lib.makeBinPath [ tk ]}
    wrapProgram $out/bin/pd-gui --prefix PATH : ${lib.makeBinPath [ tk ]}
  '';

  meta = {
    description = "Real-time graphical programming environment for audio, video, and graphical processing";
    homepage = "http://puredata.info";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    mainProgram = "pd";
  };
})
