{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  appstream,
  desktop-file-utils,
  gtk4,
  glib,
  itstool,
  poppler,
  djvulibre,
  libarchive,
  libsecret,
  wrapGAppsHook4,
  gobject-introspection,
  gsettings-desktop-schemas,
  dbus,
  libadwaita,
  # TODO: blueprint-compiler - not available
  # TODO: pango - not available (as standalone dep)
  # TODO: gdk-pixbuf - not available
  # TODO: shared-mime-info - not available
  # TODO: nautilus - not available
  # TODO: librsvg - not available
  # TODO: yelp-tools - not available
  # TODO: gi-docgen - not available
  # TODO: libsysprof-capture - not available
  # TODO: libspelling - not available
  # TODO: exempi - not available
  # TODO: rustPlatform - not available (cargo, rustPlatform.cargoSetupHook, rustPlatform.fetchCargoVendor)
  # TODO: libspectre - available but papers may need it for PostScript support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "50.2";

  outputs = [
    "out"
    "dev"
    # TODO: "devdoc" - needs gi-docgen
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/papers/${lib.versions.major finalAttrs.version}/papers-${finalAttrs.version}.tar.xz";
    hash = "sha256-rhvc8c1Hy1DJ2EdleEYH+Bxy3xfdbmrZM/6hQXPSufQ=";
  };

  # TODO: cargoDeps = rustPlatform.fetchCargoVendor { ... hash = "sha256-6Fd6V0Ksl8jqoM1znyYI0Mve2QQU+JBf3yn2C2Bcda8="; };

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gobject-introspection
    # TODO: gi-docgen
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook4
    # TODO: yelp-tools
    # TODO: cargo
    # TODO: blueprint-compiler
    # TODO: rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    dbus # only needed to find the service directory
    djvulibre
    # TODO: exempi
    # TODO: gdk-pixbuf
    glib
    gtk4
    gsettings-desktop-schemas
    libadwaita
    libarchive
    # TODO: librsvg
    # TODO: libsysprof-capture
    # TODO: libspelling
    # TODO: pango
    poppler
    libsecret
    # TODO: nautilus (optional)
  ];

  mesonFlags = [
    # TODO: re-enable nautilus when available
    "-Dnautilus=false"
  ];

  # TODO: requires Rust build support
  # env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  # TODO: postPatch for Rust target path substitution
  # postPatch = ''
  #   substituteInPlace shell/src/meson.build thumbnailer/meson.build --replace-fail \
  #     "meson.current_build_dir() / rust_target / meson.project_name()" \
  #     "meson.current_build_dir() / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  # '';

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/papers.thumbnailer \
      --replace-fail '=papers-thumbnailer' "=$out/bin/papers-thumbnailer"
  '';

  # TODO: restore shared-mime-info XDG_DATA_DIRS prefix when available
  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
  #   )
  # '';

  # TODO: restore when devdoc output is enabled
  # postFixup = ''
  #   moveToOutput "share/doc" "$devdoc"
  # '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/papers";
    changelog = "https://gitlab.gnome.org/GNOME/papers/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "GNOME's document viewer";
    longDescription = ''
      papers is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, and TIFF (not DVI anymore).
      The goal of papers is to replace the evince document viewer that exist
      on the GNOME Desktop with a more modern interface.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "papers";
  };
})
