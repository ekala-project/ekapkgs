{
  fetchurl,
  fetchpatch,
  replaceVars,
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  json-glib,
  gettext,
  libsecret,
  python3,
  polkit,
  gobject-introspection,
  wrapGAppsHook4,
  gcr_4,
  accountsservice,
  upower,
  ibus,
  gnome-desktop,
  gsettings-desktop-schemas,
  gnome-keyring,
  glib,
  gtk4,
  libadwaita,
  systemd,
  libxml2,
  # TODO: gjs - being ported
  # TODO: mutter - being ported
  # TODO: gnome-settings-daemon - being ported
  # TODO: evolution-data-server (evolution-data-server-gtk4) - being ported
  # TODO: libgweather - being ported
  # TODO: tinysparql - being ported (for gnome-autoar)
  # TODO: networkmanager - not available
  # TODO: libnma (libnma-gtk4) - not available
  # TODO: webkitgtk (webkitgtk_6_0) - not available
  # TODO: gnome-bluetooth - not available (gnome-bluetooth_1_0)
  # TODO: docutils - not yet available in ekapkgs
  # TODO: gi-docgen - not yet available in ekapkgs
  # TODO: sassc - not yet available in ekapkgs
  # TODO: desktop-file-utils - not yet available in ekapkgs
  # TODO: libxslt - not yet available in ekapkgs
  # TODO: at-spi2-core - not yet available in ekapkgs
  # TODO: gdk-pixbuf - not yet available in ekapkgs
  # TODO: gdm - being ported (circular dep, needs careful handling)
  # TODO: geoclue2 - available in ekapkgs but not used here yet
  # TODO: adwaita-icon-theme - not yet available in ekapkgs
  # TODO: gnome-clocks - not yet available in ekapkgs
  # TODO: libpulseaudio - not yet available in ekapkgs
  # TODO: libical - not yet available in ekapkgs
  # TODO: librsvg - not yet available in ekapkgs
  # TODO: lcms2 - not yet available in ekapkgs
  # TODO: pipewire - not yet available in ekapkgs
  # TODO: gstreamer - not yet available in ekapkgs
  # TODO: gnome-autoar - not yet available in ekapkgs
  # TODO: bash-completion - not yet available in ekapkgs
  # TODO: shared-mime-info - not yet available in ekapkgs
  # TODO: glycin-loaders - not yet available in ekapkgs
  # TODO: unzip - not yet available in ekapkgs
  # TODO: libsoup_3 - not yet available in ekapkgs
  # TODO: libgbm - not yet available in ekapkgs
  # TODO: libGL - not yet available in ekapkgs
  # TODO: libxi - not yet available in ekapkgs
  # TODO: libx11 - not yet available in ekapkgs
  # TODO: libxkbcommon - not yet available in ekapkgs
}:

let
  pythonEnv = python3.withPackages (
    ps:
    lib.filter (p: p != null) [
      (ps.pygobject3 or null)
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-shell";
  version = "50.4";

  outputs = [
    "out"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-shell/${lib.versions.major finalAttrs.version}/gnome-shell-${finalAttrs.version}.tar.xz";
    hash = "sha256-xTGTlTnbMWpBrvI2cDcKvRMw0yVPhLyw+fTa5dbjYs8=";
  };

  patches = [
    # Hardcode paths to various dependencies so that they can be found at runtime.
    # TODO: requires replaceVars with glib and unzip paths once deps are available
    # (replaceVars ./fix-paths.patch {
    #   glib_compile_schemas = "${glib.dev}/bin/glib-compile-schemas";
    #   gsettings = "${glib.bin}/bin/gsettings";
    #   unzip = "${lib.getBin unzip}/bin/unzip";
    # })

    # Use absolute path for libshew installation to make our patched gobject-introspection
    # aware of the location to hardcode in the generated GIR file.
    ./shew-gir-path.patch

    # Make D-Bus services wrappable.
    ./wrap-services.patch

    # Fix greeter logo being too big.
    # https://gitlab.gnome.org/GNOME/gnome-shell/issues/2591
    # Reverts https://gitlab.gnome.org/GNOME/gnome-shell/-/merge_requests/1101
    ./greeter-logo-size.patch

    # Work around failing fingerprint auth
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/gnome-shell/raw/dcd112d9708954187e7490564c2229d82ba5326f/f/0001-gdm-Work-around-failing-fingerprint-auth.patch";
      hash = "sha256-mgXty5HhiwUO1UV3/eDgWtauQKM0cRFQ0U7uocST25s=";
    })
  ];

  nativeBuildInputs = [
    # TODO: docutils (for rst2man)
    meson
    ninja
    pkg-config
    gettext
    # TODO: gi-docgen
    wrapGAppsHook4
    # TODO: sassc
    # TODO: desktop-file-utils
    # TODO: libxslt
    gobject-introspection
  ];

  buildInputs = [
    systemd
    gsettings-desktop-schemas
    gnome-keyring
    glib
    gcr_4
    accountsservice
    libsecret
    polkit
    # TODO: gdk-pixbuf
    # TODO: librsvg
    # TODO: networkmanager - not available
    # TODO: gjs - being ported
    # TODO: mutter - being ported
    # TODO: libpulseaudio
    # TODO: evolution-data-server-gtk4 - being ported
    # TODO: libical
    gtk4
    libadwaita
    # TODO: gdm - being ported (circular dep)
    # TODO: geoclue2
    # TODO: adwaita-icon-theme
    # TODO: gnome-bluetooth - not available
    # TODO: gnome-clocks
    # TODO: at-spi2-core
    upower
    ibus
    gnome-desktop
    # TODO: gnome-settings-daemon - being ported
    # TODO: lcms2
    # TODO: libgbm
    # TODO: libGL
    # TODO: libxi
    # TODO: libx11
    # TODO: libxkbcommon
    # TODO: libsoup_3
    libxml2

    # recording
    # TODO: pipewire
    # TODO: gstreamer / gst-plugins-base / gst-plugins-good

    # not declared at build time, but typelib is needed at runtime
    # TODO: libgweather - being ported
    # TODO: libnma-gtk4 - not available
    # TODO: webkitgtk_6_0 - not available (for gnome-shell-portal-helper)

    # for gnome-extension tool
    # TODO: bash-completion
    # TODO: gnome-autoar
    json-glib

    # for tools
    pythonEnv
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Dtests=false"
  ];

  postPatch = ''
    patchShebangs \
      src/data-to-c.py \
      build-aux/generate-app-list.py

    # We can generate it ourselves.
    rm -f man/gnome-shell.1
    rm data/theme/gnome-shell-{light,dark}.css

    # TODO: uncomment once gjs is available
    # substituteInPlace meson.build subprojects/extensions-app/meson.build \
    #   --replace-fail "gjs = find_program('gjs')" "gjs = find_program('gjs-path-here')"
  '';

  # TODO: uncomment once mutter is available
  # preInstall = ''
  #   # gnome-shell contains GSettings schema overrides for Mutter.
  #   schemadir="$out/share/glib-2.0/schemas"
  #   mkdir -p "$schemadir"
  #   cp "${glib.getSchemaPath mutter}/org.gnome.mutter.gschema.xml" "$schemadir"
  # '';

  # TODO: uncomment once pixbuf loader deps are available
  # postInstall = ''
  #   export GDK_PIXBUF_MODULE_FILE="..."
  # '';

  # TODO: uncomment once shared-mime-info and glycin-loaders are available
  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     --prefix XDG_DATA_DIRS : ...
  #   )
  # '';

  postFixup = ''
    # The services need typelibs.
    for svc in org.gnome.ScreenSaver org.gnome.Shell.Extensions org.gnome.Shell.Notifications org.gnome.Shell.Screencast; do
      wrapGApp $out/share/gnome-shell/$svc
    done

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    mozillaPlugin = "/lib/mozilla/plugins";
  };

  strictDeps = true;

  meta = {
    description = "Core user interface for the GNOME desktop";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-shell";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-shell/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
