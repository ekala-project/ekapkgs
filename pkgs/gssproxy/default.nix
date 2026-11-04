{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ding-libs,
  krb5,
  libverto,
  popt,
  libxml2,
  libxslt,
  docbook-xsl-nons,
  docbook-xml-dtd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gssproxy";
  version = "0.9.2";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gssapi";
    repo = "gssproxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RcT1ge/XxhTaT9hrvcHElAEAbvOtjqep3kdEw5e7WZY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook-xsl-nons
    docbook-xml-dtd.v4_4
    libxml2
    libxslt
    pkg-config
  ];

  makeFlags = [
    "SGML_CATALOG_FILES=${docbook-xsl-nons}/xml/xsl/docbook/catalog.xml ${docbook-xml-dtd.v4_4}/xml/dtd/docbook/catalog.xml"
    "VERTO_CFLAGS=${libverto}/include"
    "VERTO_LIBS=${libverto}/lib/libverto.so"
  ];

  postInstall = ''
    find $out -type d -empty -delete
  '';

  buildInputs = [
    ding-libs
    krb5
    libverto
    popt
  ];

  configureFlags = [
    "--with-pubconf-path=${placeholder "out"}/etc/gssproxy"
    "--with-initscript=none"
    "--without-selinux"
    "--with-gpp-default-behavior=REMOTE_FIRST"
    "--with-xml-catalog-path=${docbook-xsl-nons}/xml/xsl/docbook/catalog.xml"
  ];

  meta = {
    description = "GSS-API proxy client library for credential isolation";
    homepage = "https://github.com/gssapi/gssproxy";
    license = lib.licenses.mit;
    mainProgram = "gssproxy";
    platforms = lib.platforms.all;
  };
})
