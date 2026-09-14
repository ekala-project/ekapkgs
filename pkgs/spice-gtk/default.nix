{
  lib,
  stdenv,
  fetchurl,
  acl,
  cyrus_sasl,
  docbook_xsl,
  libepoxy,
  gettext,
  gobject-introspection,
  gst_all_1,
  gtk-doc,
  gtk3,
  hwdata,
  json-glib,
  libcacard,
  libcap_ng,
  libdrm,
  libjpeg_turbo,
  libopus,
  libsoup_3,
  libusb1,
  lz4,
  meson,
  mesonEmulatorHook,
  ninja,
  openssl,
  perl,
  phodav,
  pixman,
  pkg-config,
  polkit,
  python3,
  spice-protocol,
  usbredir,
  vala,
  wayland-protocols,
  wayland-scanner,
  zlib,
  wrapGAppsHook3,
  withPolkit ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spice-gtk";
  version = "0.42";

  outputs = [
    "out"
    "dev"
    "devdoc"
    "man"
  ];

  src = fetchurl {
    url = "https://www.spice-space.org/download/gtk/spice-gtk-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-k4ARfxgRrR+qGBLLZgJHm2KQ1KDYzEQtREJ/f2wOelg=";
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docbook_xsl
    gettext
    gobject-introspection
    gtk-doc
    meson
    meson.configurePhaseHook
    ninja
    perl
    pkg-config
    python3
    python3.pkgs.pyparsing
    python3.pkgs.six
    vala
    wrapGAppsHook3
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    mesonEmulatorHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland-scanner
  ];

  buildInputs = [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    cyrus_sasl
    libepoxy
    gtk3
    json-glib
    libcacard
    libjpeg_turbo
    libopus
    libsoup_3
    libusb1
    lz4
    openssl
    phodav
    pixman
    spice-protocol
    usbredir
    vala
    zlib
  ]
  ++ lib.optionals withPolkit [
    polkit
    acl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap_ng
    libdrm
    wayland-protocols
  ];

  env.PKG_CONFIG_POLKIT_GOBJECT_1_POLICYDIR = "${placeholder "out"}/share/polkit-1/actions";

  mesonFlags = [
    "-Dusb-acl-helper-dir=${placeholder "out"}/bin"
    "-Dusb-ids-path=${hwdata}/share/hwdata/usb.ids"
  ]
  ++ lib.optionals (!withPolkit) [
    "-Dpolkit=disabled"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Dlibcap-ng=disabled"
    "-Degl=disabled"
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [
    "-Dcoroutine=gthread" # Fixes "Function missing:makecontext"
  ];

  postPatch = ''
    # get rid of absolute path to helper in store so we can use a setuid wrapper
    substituteInPlace src/usb-acl-helper.c \
      --replace-fail 'ACL_HELPER_PATH"/' '"'
    # don't try to setcap/suid in a nix builder
    substituteInPlace src/meson.build \
      --replace-fail "meson.add_install_script('../build-aux/setcap-or-suid'," \
      "# meson.add_install_script('../build-aux/setcap-or-suid',"

    patchShebangs subprojects/keycodemapdb/tools/keymap-gen
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # don't use version script and don't export symbols
    substituteInPlace src/meson.build \
      --replace-fail "spice_gtk_version_script = [" "# spice_gtk_version_script = [" \
      --replace-fail ",--version-script=@0@'.format(spice_client_glib_syms_path)" "'"
  '';

  meta = {
    description = "GTK 3 SPICE widget";
    longDescription = ''
      spice-gtk is a GTK 3 SPICE widget. It features glib-based
      objects for SPICE protocol parsing and a gtk widget for embedding
      the SPICE display into other applications such as virt-manager.
      Python bindings are available too.
    '';

    homepage = "https://www.spice-space.org/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
  };
})
