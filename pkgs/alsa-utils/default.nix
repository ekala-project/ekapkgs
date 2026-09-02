{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  gettext,
  makeWrapper,
  pkg-config,
  ncurses,
  libsamplerate,
  pciutils,
  procps,
  tree,
  which,
  fftw,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-utils";
  version = "1.2.14";

  src = fetchurl {
    url = "mirror://alsa/utils/alsa-utils-${finalAttrs.version}.tar.bz2";
    hash = "sha256-B5THTTP+2UPnxQYJwTCJ5AkxK2xAPWromE/EKcCWB0E=";
  };

  nativeBuildInputs = [
    gettext
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    ncurses
    libsamplerate
    fftw
  ];

  configureFlags = [
    "--disable-xmlto"
    "--with-udev-rules-dir=$(out)/lib/udev/rules.d"
  ];

  installFlags = [ "ASOUND_STATE_DIR=$(TMPDIR)/dummy" ];

  postFixup = ''
    mv $out/bin/alsa-info.sh $out/bin/alsa-info
    wrapProgram $out/bin/alsa-info --prefix PATH : "${
      lib.makeBinPath [
        which
        pciutils
        procps
        tree
      ]
    }" --prefix PATH : $out/bin
  '';

  postInstall = ''
    rm -rf $out/lib/udev
  '';

  meta = {
    homepage = "http://www.alsa-project.org/";
    description = "ALSA, the Advanced Linux Sound Architecture utils";
    license = with lib.licenses; [
      gpl2Plus
      gpl2Only
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
