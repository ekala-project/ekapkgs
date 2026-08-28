{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  fltk,
  gtk2,
  gtk3,
  makeWrapper,
  pkg-config,
  psmisc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "alsa-tools";
  version = "1.2.14";

  src = fetchurl {
    url = "mirror://alsa/tools/alsa-tools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-+u9v3TnsecmlRz3GOqG2Mxv3ZkqdRSoKgZjOxwFsvG8=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fltk
    gtk2
    gtk3
    psmisc
  ];

  env.TOOLSET = lib.concatStringsSep " " [
    "as10k1"
    "echomixer"
    "envy24control"
    "hda-verb"
    "hdajackretask"
    "hdajacksensetest"
    "hdspconf"
    "hdsploader"
    "hdspmixer"
    "ld10k1"
    "mixartloader"
    "pcxhrloader"
    "rmedigicontrol"
    "sb16_csp"
    "sscape_ctl"
    "us428control"
    "vxloader"
  ];

  configurePhase = ''
    runHook preConfigure

    for tool in $TOOLSET; do
      echo "Configuring $tool:"
      pushd "$tool"
      ./configure --prefix="$out"
      popd
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    for tool in $TOOLSET; do
      echo "Building $tool:"
      pushd "$tool"
      make
      popd
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for tool in $TOOLSET; do
      echo "Installing $tool:"
      pushd "$tool"
      make install
      popd
    done

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/hdajackretask \
      --prefix PATH : ${lib.makeBinPath [ psmisc ]}

    runHook postFixup
  '';

  meta = {
    description = "ALSA Tools";
    homepage = "http://www.alsa-project.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
