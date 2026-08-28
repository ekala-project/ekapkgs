{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchurl,
  python3Packages,
  gettext,
  itstool,
  libtool,
  texinfo,
  systemdMinimal,
  util-linux,
  autoreconfHook,
  glib,
  dotconf,
  libsndfile,
  libao,
  pcaudiolib,
}:

let
  inherit (python3Packages) python wrapPython;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "speech-dispatcher";
  version = "0.12.1";

  src = fetchurl {
    url = "https://github.com/brailcom/speechd/releases/download/${finalAttrs.version}/speech-dispatcher-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-sUpSONKH0tzOTdQrvWbKZfoijn5oNwgmf3s0A297pLQ=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      utillinux = util-linux;
      bindir = null;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    libtool
    itstool
    texinfo
    wrapPython
  ];

  buildInputs = [
    glib
    dotconf
    libsndfile
    libao
    python
    systemdMinimal
    pcaudiolib
  ];

  configureFlags = [
    "--with-default-audio-method=\"libao,pulse,alsa,oss\""
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "--with-libao"
    "--without-pulse"
    "--without-alsa"
    "--without-flite"
    "--without-pico"
    "--without-espeak-ng"
  ];

  postInstall = ''
    rm -rf $out/{bin,etc,lib/speech-dispatcher,lib/systemd,libexec,share}
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Common interface to speech synthesis - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "speech-dispatcher";
  };
})
