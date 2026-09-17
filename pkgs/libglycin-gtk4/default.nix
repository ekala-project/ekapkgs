{
  lib,
  stdenv,
  cargo,
  fontconfig,
  gi-docgen,
  glib,
  gobject-introspection,
  gtk4,
  lcms2,
  libglycin,
  libseccomp,
  meson,
  ninja,
  pkg-config,
  python3,
  rustPlatform,
  rustc,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libglycin-gtk4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  inherit (libglycin) version src cargoDeps;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustc
    cargo
    python3
    rustPlatform.cargoSetupHook
    vala
    gi-docgen
    gobject-introspection
  ];

  buildInputs = [
    fontconfig
    glib
    libseccomp
    lcms2
    gtk4
  ];

  propagatedBuildInputs = [
    libglycin
    gtk4
    fontconfig
    libseccomp
    lcms2
  ];

  strictDeps = true;

  mesonFlags = [
    (lib.mesonBool "glycin-loaders" false)
    (lib.mesonBool "glycin-thumbnailer" false)
    (lib.mesonBool "libglycin" false)
    (lib.mesonBool "libglycin-gtk4" true)
    (lib.mesonBool "introspection" true)
    (lib.mesonBool "vapi" true)
    (lib.mesonBool "capi_docs" true)
  ];

  postPatch = ''
    patchShebangs \
      build-aux/crates-version.py
    substituteInPlace libglycin/meson.build --replace-fail \
      "cargo_output = cargo_target_dir / rust_target" \
      "cargo_output = cargo_target_dir / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target"
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "C-Bindings to convert glycin frames to GDK Textures";
    homepage = "https://gitlab.gnome.org/GNOME/glycin";
    license = with lib.licenses; [
      mpl20
      lgpl21Plus
    ];
    platforms = lib.platforms.linux;
  };
})
