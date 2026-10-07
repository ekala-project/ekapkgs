{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk4,
  libadwaita,
  libepoxy,
  libGL,
  libxkbcommon,
  fontconfig,
  gtk4-layer-shell,
  wayland,
  gdk-pixbuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tensaku";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "jondkinney";
    repo = "tensaku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IAjvMaN0R+dPtdOR26uLYRT+yjpIz/ZA3V4pKa6nue4=";
  };

  cargoHash = "sha256-q+jS+NX/AKWwaidEQrJMF2hMW+UCb1XJ9zA9Tc5iH5A=";

  nativeBuildInputs = [
    pkg-config
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    gtk4
    libadwaita
    libepoxy
    libGL
    libxkbcommon
    fontconfig
    gtk4-layer-shell
    wayland
    gdk-pixbuf
  ];

  doCheck = false;

  meta = {
    description = "Modern screenshot annotation tool for Wayland";
    homepage = "https://github.com/jondkinney/tensaku";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    mainProgram = "tensaku";
  };
})
