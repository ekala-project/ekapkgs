{
  lib,
  stdenv,
  cargo,
  fetchFromGitLab,
  gi-docgen,
  gobject-introspection,
  json-glib,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libipuz";
  version = "0.5.4";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "jrb";
    repo = "libipuz";
    rev = finalAttrs.version;
    hash = "sha256-rUFYPtedcNqba2OLPo9nSjyGxuc3Q3RNoOmZx+RUOcU=";
  };

  cargoRoot = "libipuz/rust";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      src
      version
      cargoRoot
      ;
    hash = "sha256-NbK++me/tOrl0MyxvyTIK9UWyR0jU3pkJ6c5sNjuY2M=";
  };

  nativeBuildInputs = [
    cargo
    gi-docgen
    gobject-introspection
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    json-glib
  ];

  meta = {
    description = "Library for parsing .ipuz puzzle files";
    homepage = "https://gitlab.gnome.org/jrb/libipuz";
    changelog = "https://gitlab.gnome.org/jrb/libipuz/-/blob/${finalAttrs.version}/NEWS.md?ref_type=tags";
    license = with lib.licenses; [
      lgpl21Plus
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
