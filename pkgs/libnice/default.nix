{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  gobject-introspection,
  gtk-doc,
  docbook-xsl,
  docbook-xml-dtd,
  glib,
  gnutls,
  graphviz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnice";
  version = "0.1.22";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://libnice.freedesktop.org/releases/libnice-${finalAttrs.version}.tar.gz";
    hash = "sha256-pfckzwnq5QxBp1FxQdidpKYeyerKMtpKAHP67VQXrX4=";
  };

  nativeBuildInputs = [
    meson
    meson.configurePhaseHook
    ninja
    pkg-config
    python3
    gobject-introspection
    gtk-doc
    docbook-xsl
    docbook-xml-dtd.v4_1_2
    graphviz
  ];

  buildInputs = [
    gnutls
  ];

  propagatedBuildInputs = [
    glib
  ];

  mesonFeatures = {
    gstreamer = false;
    gupnp = false;
    gtk_doc = false;
    introspection = true;
    examples = false;
    tests = false;
  };

  doCheck = false;

  meta = {
    description = "GLib ICE implementation";
    homepage = "https://libnice.freedesktop.org/";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl21
      mpl11
    ];
  };
})
