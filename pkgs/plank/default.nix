{
  lib,
  stdenv,
  fetchurl,
  vala,
  at-spi2-core,
  cairo,
  dconf,
  glib,
  gnome-common,
  gtk3,
  libwnck,
  libx11,
  libxfixes,
  libxi,
  pango,
  gettext,
  pkg-config,
  libxml2,
  bamf,
  gdk-pixbuf,
  libdbusmenu,
  file,
  gnome-menus,
  libgee,
  autoreconfHook,
}:

let
  # plank is a Vala application and needs GIR/VAPI files from its dependencies.
  # corepkgs builds gtk3 without introspection by default; override here so
  # libdbusmenu-gtk3 can generate the Dbusmenu-0.4 and DbusmenuGtk3-0.4 vapi
  # files that plank's Vala compiler requires.
  gtk3WithGir = gtk3.override { withIntrospection = true; };
  libdbusmenu-gtk3 = libdbusmenu.gtk3.override { gtk3 = gtk3WithGir; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "plank";
  version = "0.11.89";

  src = fetchurl {
    url = "https://launchpad.net/plank/1.0/${finalAttrs.version}/+download/plank-${finalAttrs.version}.tar.xz";
    sha256 = "17cxlmy7n13jp1v8i4abxyx9hylzb39andhz3mk41ggzmrpa8qm6";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    gnome-common
    libxml2 # xmllint
    pkg-config
    vala
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    at-spi2-core
    bamf
    cairo
    gdk-pixbuf
    glib
    gnome-menus
    dconf
    gtk3WithGir
    libx11
    libxfixes
    libxi
    libdbusmenu-gtk3
    libgee
    libwnck
    pango
  ];

  # fix paths
  makeFlags = [
    "INTROSPECTION_GIRDIR=${placeholder "out"}/share/gir-1.0/"
    "INTROSPECTION_TYPELIBDIR=${placeholder "out"}/lib/girepository-1.0"
  ];

  # Make plank's application launcher hidden in Pantheon
  patches = [
    ./hide-in-pantheon.patch
  ];

  postPatch = ''
    substituteInPlace ./configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  meta = {
    description = "Elegant, simple, clean dock";
    mainProgram = "plank";
    homepage = "https://launchpad.net/plank";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
