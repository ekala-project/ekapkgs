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
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpredict";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "csete";
    repo = "gpredict";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DX+9SHD3VJnpSc58DRoSlqeEoj3CKEHbnhmFqJRYDBQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
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
    maintainers = [ ];
  };
})
