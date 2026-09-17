{
  stdenv,
  fetchurl,
  meson,
  ninja,
  gettext,
  gtk-doc,
  pkg-config,
  vala,
  networkmanager,
  isocodes,
  libxml2,
  docbook_xsl,
  docbook_xml_dtd_43,
  mobile-broadband-provider-info,
  gobject-introspection,
  gtk3,
  withGtk4 ? false,
  gtk4 ? null,
  withGnome ? true,
  gcr_4,
  glib,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnma";
  version = "1.10.6";

  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/libnma/${lib.versions.majorMinor finalAttrs.version}/libnma-${finalAttrs.version}.tar.xz";
    sha256 = "U6b7KxkK03xZhsrtPpi+3nw8YCOZ7k+TyPwFQwPXbas=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    gettext
    pkg-config
    gobject-introspection
    gtk-doc
    docbook_xsl
    docbook_xml_dtd_43
    libxml2
    vala
  ];

  buildInputs = [
    gtk3
    networkmanager
    isocodes
    mobile-broadband-provider-info
  ]
  ++ lib.optionals withGtk4 [
    gtk4
  ]
  ++ lib.optionals withGnome [
    gcr_4
  ];

  mesonFlags = [
    "-Dgcr=${lib.boolToString withGnome}"
    "-Dlibnma_gtk4=${lib.boolToString withGtk4}"
  ];

  postPatch = ''
    substituteInPlace src/nma-ws/nma-eap.c --subst-var-by \
      NM_APPLET_GSETTINGS ${glib.makeSchemaPath "$out" "$name"}
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/libnma";
    description = "NetworkManager UI utilities (libnm version)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
