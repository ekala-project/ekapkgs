{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gettext,
  libxml2,
  appstream,
  desktop-file-utils,
  glib,
  gtk3,
  pango,
  at-spi2-core,
  gdk-pixbuf,
  shared-mime-info,
  itstool,
  poppler,
  ghostscript ? null,
  djvulibre,
  libspectre,
  libarchive,
  libgxps,
  libhandy,
  libsecret,
  wrapGAppsHook3,
  librsvg,
  gobject-introspection,
  yelp-tools,
  gspell,
  gsettings-desktop-schemas,
  gnome-desktop,
  dbus,
  gstreamer,
  gi-docgen,
  supportMultimedia ? true, # PDF multimedia
  withLibsecret ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evince";
  version = "48.4";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/evince/${lib.versions.major finalAttrs.version}/evince-${finalAttrs.version}.tar.xz";
    hash = "sha256-8pbFxmKIZjXUzVl+isCvzeeYK+RIZTPCt/CVsmi+hmg=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    appstream
    desktop-file-utils
    gettext
    gobject-introspection
    gi-docgen
    itstool
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    wrapGAppsHook3
    yelp-tools
  ];

  buildInputs = [
    at-spi2-core
    dbus # only needed to find the service directory
    djvulibre
    gdk-pixbuf
    glib
    gnome-desktop
    gsettings-desktop-schemas
    gspell
    gtk3
    libarchive
    libgxps
    libhandy
    librsvg
    libspectre
    libxml2
    pango
    poppler
  ]
  ++ lib.optionals (ghostscript != null) [ ghostscript ]
  ++ lib.optionals withLibsecret [
    libsecret
  ]
  ++ lib.optionals supportMultimedia (
    with gstreamer;
    [
      gstreamer
      plugins-base
      plugins-good
      plugins-bad
      plugins-ugly
    ]
  );

  mesonFlags = [
    "-Dnautilus=false"
  ]
  ++ lib.optionals (ghostscript != null) [
    "-Dps=enabled"
  ]
  ++ lib.optionals (ghostscript == null) [
    "-Dps=disabled"
  ]
  ++ lib.optionals (!withLibsecret) [
    "-Dkeyring=disabled"
  ]
  ++ lib.optionals (!supportMultimedia) [
    "-Dmultimedia=disabled"
  ];

  # Fix build with gcc15
  env.NIX_CFLAGS_COMPILE = toString [
    "-DHAVE_STRING_H"
    "-DHAVE_STDLIB_H"
  ];

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/evince.thumbnailer \
      --replace-fail "TryExec=evince-thumbnailer" "TryExec=$out/bin/evince-thumbnailer" \
      --replace-fail "Exec=evince-thumbnailer" "Exec=$out/bin/evince-thumbnailer"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  postFixup = ''
    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  meta = {
    homepage = "https://apps.gnome.org/Evince/";
    description = "GNOME's document viewer";

    longDescription = ''
      Evince is a document viewer for multiple document formats.  It
      currently supports PDF, PostScript, DjVu, TIFF and DVI.  The goal
      of Evince is to replace the multiple document viewers that exist
      on the GNOME Desktop with a single simple application.
    '';

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "evince";
  };
})
