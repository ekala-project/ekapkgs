{
  lib,
  # TODO: rustPlatform not yet available
  fetchurl,
  wrapGAppsHook4,
  meson,
  vala,
  pkg-config,
  ninja,
  itstool,
  gtk4,
  libadwaita,
  stdenv,
  # TODO: rustc not yet available
  # TODO: cargo not yet available
  desktop-file-utils,
  # TODO: writableTmpDirAsHomeHook not yet available
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-2048";
  version = "50.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-2048/${lib.versions.major finalAttrs.version}/gnome-2048-${finalAttrs.version}.tar.xz";
    hash = "sha256-bRXfaKYSjPDJnlmJCK+MZntzPcQAPvTSHUtMSkK9Lak=";
  };

  # TODO: cargoDeps requires rustPlatform.fetchCargoVendor
  # cargoDeps = rustPlatform.fetchCargoVendor {
  #   inherit (finalAttrs) pname version src;
  #   hash = "sha256-OcuhISJhm8uvcJjki86FSNiT5AoqUrILZaHcn1oZVtk=";
  # };

  strictDeps = true;

  nativeBuildInputs = [
    itstool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
    # TODO: rustPlatform.cargoSetupHook not yet available
    # TODO: rustc not yet available
    # TODO: cargo not yet available
    desktop-file-utils
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  # TODO: nativeCheckInputs requires writableTmpDirAsHomeHook and rustPlatform.cargoCheckHook

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-2048";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-2048/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Obtain the 2048 tile";
    mainProgram = "gnome-2048";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
