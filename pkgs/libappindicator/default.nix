{
  stdenv,
  fetchgit,
  lib,
  pkg-config,
  autoreconfHook,
  glib,
  dbus-glib,
  gtk3,
  libindicator,
  libdbusmenu-gtk3,
  gtk-doc,
  vala,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libappindicator-gtk3";
  version = "12.10.1+20.10.20200706.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/libappindicator";
    rev = "fe25e53bc7e39cd59ad6b3270cd7a6a9c78c4f44";
    sha256 = "0xjvbl4gn7ra2fs6gn2g9s787kzb5cg9hv79iqsz949rxh4iw32d";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    vala
    gobject-introspection
    gtk-doc
  ];

  propagatedBuildInputs = [
    gtk3
    libdbusmenu-gtk3
  ];

  buildInputs = [
    glib
    dbus-glib
    libindicator
  ];

  preAutoreconf = ''
    gtkdocize
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gtk=3"
    # TODO(ekapkgs): re-enable when gtk3 provides Gtk-3.0.gir
    "--disable-introspection"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  meta = {
    description = "Library to allow applications to export a menu into the Unity Menu bar";
    homepage = "https://launchpad.net/libappindicator";
    license = with lib.licenses; [
      lgpl21
      lgpl3
    ];
    platforms = lib.platforms.linux;
  };
})
