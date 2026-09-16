{
  stdenv,
  fetchurl,
  lib,
  file,
  pkg-config,
  intltool,
  glib,
  dbus-glib,
  json-glib,
  gobject-introspection,
  vala,
  withGtk3 ? false,
  gtk3,
  gtkVersion ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdbusmenu-${if withGtk3 then "gtk3" else "glib"}";
  version = "16.04.0";

  src =
    let
      inherit (finalAttrs) version;
    in
    fetchurl {
      url = "https://launchpad.net/dbusmenu/${lib.versions.majorMinor version}/${version}/+download/libdbusmenu-${version}.tar.gz";
      sha256 = "12l7z8dhl917iy9h02sxmpclnhkdjryn08r8i4sr8l3lrlm4mk5r";
    };

  nativeBuildInputs = [
    vala
    pkg-config
    intltool
    gobject-introspection
  ];

  buildInputs = [
    glib
    dbus-glib
    json-glib
  ]
  ++ lib.optional withGtk3 gtk3;

  patches = [
    ./requires-glib.patch
  ];

  postPatch = ''
    for f in {configure,ltmain.sh,m4/libtool.m4}; do
      substituteInPlace $f \
        --replace /usr/bin/file ${file}/bin/file
    done
  '';

  preConfigure = ''
    export HAVE_VALGRIND_TRUE="#"
    export HAVE_VALGRIND_FALSE=""
  '';

  configureFlags = [
    "CFLAGS=-Wno-error"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    (if withGtk3 then "--with-gtk=3" else "--disable-gtk")
    "--disable-dumper"
    "--disable-scrollkeeper"
  ]
  # TODO(ekapkgs): re-enable introspection/vala when gtk3 provides Gtk-3.0.gir
  ++ lib.optionals withGtk3 [
    "--disable-introspection"
    "--disable-vala"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
    "typelibdir=${placeholder "out"}/lib/girepository-1.0"
  ];

  meta = {
    description = "Library for passing menu structures across DBus";
    homepage = "https://launchpad.net/dbusmenu";
    license = with lib.licenses; [
      gpl3
      lgpl21
      lgpl3
    ];
    platforms = lib.platforms.unix;
  };
})
