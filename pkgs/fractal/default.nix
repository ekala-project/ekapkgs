{
  stdenv,
  lib,
  fetchFromGitLab,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  grass-sass,
  gtk4,
  gtksourceview5,
  lcms2,
  libadwaita,
  gstreamer,
  desktop-file-utils,
  appstream-glib,
  openssl,
  pipewire,
  libshumate,
  blueprint-compiler,
  sqlite,
  xdg-desktop-portal,
  libseccomp,
  libglycin-gtk4,
  glycin-loaders,
  libwebp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fractal";
  version = "14.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "fractal";
    tag = finalAttrs.version;
    hash = "sha256-GQdEa5JHXkpQdKcnzT4udZ0Cr4eJv4zoB7sknWnuGCI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-y3osmwhrB9x2s9V8L9qI1qs2fv2ygynq+mS+cA/KIyA=";
  };

  patches = [
    # Disable debug symbols in release builds
    # The debug symbols are stripped afterwards anyways, and building with them requires extra memory
    ./disable-debug.patch
  ];

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "target_dir / rust_target / meson.project_name()" \
      "target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"

    patchShebangs ./build-aux/compile-blueprints.sh
  '';

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    cargo
    desktop-file-utils
    glib
    grass-sass
    gtk4
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    gtk4.wrapGAppsHook
  ];

  buildInputs = [
    glib
    glycin-loaders
    gtk4
    gtksourceview5
    lcms2
    libadwaita
    libglycin-gtk4
    openssl
    pipewire
    libshumate
    sqlite
    xdg-desktop-portal
    libseccomp
    libwebp
  ]
  ++ (with gstreamer; [
    gstreamer
    plugins-base
    plugins-good
    plugins-bad
    # TODO: gstreamer.plugins-rs not in ekapkgs
  ]);

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Matrix group messaging app";
    homepage = "https://gitlab.gnome.org/World/fractal";
    changelog = "https://gitlab.gnome.org/World/fractal/-/releases/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "fractal";
  };
})
