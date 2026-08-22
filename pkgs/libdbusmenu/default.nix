{
  lib,
  stdenv,
  fetchurl,
  file,
  pkg-config,
  intltool,
  glib,
  dbus-glib,
  json-glib,
  gobject-introspection,
  vala,
  gtkVersion ? null,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdbusmenu-${if gtkVersion == null then "glib" else "gtk${gtkVersion}"}";
  version = "16.04.0";

  src = fetchurl {
    url = "https://launchpad.net/dbusmenu/${lib.versions.majorMinor finalAttrs.version}/${finalAttrs.version}/+download/libdbusmenu-${finalAttrs.version}.tar.gz";
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
  ++ lib.optional (gtkVersion == "3") gtk3;

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
    (if gtkVersion == null then "--disable-gtk" else "--with-gtk=${gtkVersion}")
    "--disable-scrollkeeper"
    "--disable-introspection"
    "--disable-vala"
  ]
  ++ lib.optional (gtkVersion != "2") "--disable-dumper";

  doCheck = false;

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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
