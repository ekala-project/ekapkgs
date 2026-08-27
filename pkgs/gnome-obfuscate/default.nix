{
  stdenv,
  lib,
  fetchFromGitLab,
  buildPackages,
  # TODO: cargo not yet available in ekapkgs
  # cargo,
  gettext,
  meson,
  ninja,
  pkg-config,
  # TODO: rustPlatform not yet available in ekapkgs
  rustPlatform,
  # TODO: rustc not yet available in ekapkgs
  # rustc,
  wrapGAppsHook4,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk4,
  gdk-pixbuf,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-obfuscate";
  version = "0.0.10";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Obfuscate";
    rev = finalAttrs.version;
    hash = "sha256-/Plvvn1tle8t/bsPcsamn5d81CqnyGCyGYPF6j6U5NI=";
  };

  # TODO: cargoDeps requires rustPlatform.fetchCargoVendor
  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit (finalAttrs) pname version src;
  #   hash = "sha256-Llgn+dYNKZ9Mles9f9Xor+GZoCCQ0cERkXz4MicZglY=";
  # };

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    GETTEXT_BIN_DIR = "${lib.getBin buildPackages.gettext}/bin";
    GETTEXT_INCLUDE_DIR = "${lib.getDev gettext}/include";
    GETTEXT_LIB_DIR = "${lib.getLib gettext}/lib";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    # TODO: rustPlatform.cargoSetupHook not yet available in ekapkgs
    # rustPlatform.cargoSetupHook
    # TODO: cargo not yet available in ekapkgs
    # cargo
    # TODO: rustc not yet available in ekapkgs
    # rustc
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    gdk-pixbuf
    libadwaita
  ];

  meta = {
    description = "Censor private information";
    homepage = "https://gitlab.gnome.org/World/obfuscate";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    mainProgram = "obfuscate";
    maintainers = [ ];
  };
})
