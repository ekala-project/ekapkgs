{
  stdenv,
  lib,
  fetchurl,
  cargo,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  rustc,
  gtk4,
  lcms2,
  libadwaita,
  libgweather,
  libseccomp,
  libglycin,
  glycin-loaders,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major finalAttrs.version}/loupe-${finalAttrs.version}.tar.xz";
    hash = "sha256-euT7rl4ZMWqmQMVvgNxaeRRIpi3Y8P8G4ppYutgTqZQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-I4z5qjX10AUuwk+JdX/1ZU0uCAVPQj8HkEc+n9aMczE=";
  };

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()," \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name(),"
  '';

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    itstool
    libglycin.patchVendorHook
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    libglycin.setupHook
    glycin-loaders
    gtk4
    lcms2
    libadwaita
    libgweather
    libseccomp
  ];

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/loupe";
    description = "Simple image viewer application written with GTK4 and Rust";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "loupe";
  };
})
