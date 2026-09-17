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
  gjs,
  mutter,
  gnome-settings-daemon,
  evolution-data-server-gtk4,
  libgweather,
  tinysparql,
  networkmanager,
  # TODO: libnma-gtk4 - not available
  # TODO: webkitgtk_6_0 - not available
  gnome-bluetooth,
  docutils,
  gi-docgen,
  sassc,
  desktop-file-utils,
  libxslt,
  at-spi2-core,
  gdk-pixbuf,
  gdm,
  geoclue2,
  adwaita-icon-theme,
  gnome-clocks,
  libpulseaudio,
  libical,
  librsvg,
  lcms2,
  pipewire,
  gst_all_1,
  gnome-autoar,
  bash-completion,
  shared-mime-info,
  # TODO: glycin-loaders - not available
  unzip,
  libsoup_3,
  libgbm,
  libGL,
  libxi,
  libx11,
  libxkbcommon,
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
    (replaceVars ./fix-paths.patch {
      glib_compile_schemas = "${glib.dev}/bin/glib-compile-schemas";
      gsettings = "${glib.bin}/bin/gsettings";
      unzip = "${lib.getBin unzip}/bin/unzip";
    })

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
    docutils
    meson
    ninja
    pkg-config
    gettext
    gi-docgen
    wrapGAppsHook4
    sassc
    desktop-file-utils
    libxslt
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
    gdk-pixbuf
    librsvg
    networkmanager
    gjs
    mutter
    libpulseaudio
    evolution-data-server-gtk4
    libical
    gtk4
    libadwaita
    gdm
    geoclue2
    adwaita-icon-theme
    gnome-bluetooth
    gnome-clocks
    at-spi2-core
    upower
    ibus
    gnome-desktop
    gnome-settings-daemon
    lcms2
    libgbm
    libGL
    libxi
    libx11
    libxkbcommon
    libsoup_3
    libxml2

    # recording
    pipewire
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    # not declared at build time, but typelib is needed at runtime
    libgweather
    # TODO: libnma-gtk4 - not available
    # TODO: webkitgtk_6_0 - not available (for gnome-shell-portal-helper)

    # for gnome-extension tool
    bash-completion
    gnome-autoar
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

    substituteInPlace meson.build subprojects/extensions-app/meson.build \
      --replace-fail "gjs = find_program('gjs')" "gjs = find_program('${gjs}/bin/gjs')"
  '';

  preInstall = ''
    # gnome-shell contains GSettings schema overrides for Mutter.
    schemadir="$out/share/glib-2.0/schemas"
    mkdir -p "$schemadir"
    cp "${glib.getSchemaPath mutter}/org.gnome.mutter.gschema.xml" "$schemadir"
  '';

  # TODO: postInstall needs GDK_PIXBUF_MODULE_FILE setup (pixbuf loaders)

  # TODO: preFixup needs glycin-loaders (not yet available)
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
    platforms = lib.platforms.linux;
  };
})
