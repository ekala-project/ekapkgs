{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  intltool,
  autoreconfHook,
  gtk3,
  curl,
  gpsd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpredict";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gpredict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OlE0NycV/4h6LA+BnRxfBo0+9yWMM4qEHrs+mVx04do=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    intltool
    gtk3.wrapGAppsHook
    autoreconfHook
  ];

  buildInputs = [
    curl
    gtk3
    gpsd
  ];

  meta = {
    description = "Real time satellite tracking and orbit prediction";
    mainProgram = "gpredict";
    longDescription = ''
      Gpredict is a real time satellite tracking and orbit prediction program
      written using the GTK widgets. Gpredict is targetted mainly towards ham radio
      operators but others interested in satellite tracking may find it useful as
      well. Gpredict uses the SGP4/SDP4 algorithms, which are compatible with the
      NORAD Keplerian elements.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    homepage = "https://oz9aec.dk/gpredict/";
  };
})
