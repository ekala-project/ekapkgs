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
  blueprint-compiler,
  exempi,
  gdk-pixbuf,
  gi-docgen,
  librsvg,
  libspelling,
  libsysprof-capture,
  nautilus,
  pango,
  rustPlatform,
  cargo,
  rustc,
  shared-mime-info,
  yelp-tools,
  # TODO: libspectre - available but papers may need it for PostScript support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papers";
  version = "50.2";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/papers/${lib.versions.major finalAttrs.version}/papers-${finalAttrs.version}.tar.xz";
    hash = "sha256-rhvc8c1Hy1DJ2EdleEYH+Bxy3xfdbmrZM/6hQXPSufQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-6Fd6V0Ksl8jqoM1znyYI0Mve2QQU+JBf3yn2C2Bcda8=";
  };

  nativeBuildInputs = [
    appstream
    blueprint-compiler
    cargo
    desktop-file-utils
    gi-docgen
    gobject-introspection
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    yelp-tools
  ];

  buildInputs = [
    dbus # only needed to find the service directory
    djvulibre
    exempi
    gdk-pixbuf
    glib
    gtk4
    gsettings-desktop-schemas
    libadwaita
    libarchive
    librsvg
    libsysprof-capture
    libspelling
    nautilus
    pango
    poppler
    libsecret
  ];

  mesonFlags = [
    "-Dnautilus=true"
  ];

  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  postPatch = ''
    substituteInPlace shell/src/meson.build thumbnailer/meson.build --replace-fail \
      "meson.current_build_dir() / rust_target / meson.project_name()" \
      "meson.current_build_dir() / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()"
  '';

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/papers.thumbnailer \
      --replace-fail '=papers-thumbnailer' "=$out/bin/papers-thumbnailer"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
    )
  '';

  postFixup = ''
    moveToOutput "share/doc" "$devdoc"
  '';

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
    platforms = lib.platforms.unix;
    mainProgram = "papers";
  };
})
