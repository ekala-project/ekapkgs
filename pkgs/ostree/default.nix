{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gtk-doc,
  curl,
  glib,
  xz,
  e2fsprogs,
  libsoup_3,
  gpgme,
  which,
  makeWrapper,
  autoconf,
  automake,
  libtool,
  fuse3,
  util-linuxMinimal,
  libselinux,
  libsodium,
  libarchive,
  libcap,
  bzip2,
  bison,
  libxslt,
  docbook-xsl-nons ? null,
  docbook_xml_dtd_42,
  python3,
  buildPackages,
  gobject-introspection,
  replaceVars,
  openssl,
  withSystemd ? false,
  systemd ? null,
}:

let
  testPython = python3.withPackages (
    p: with p; [
      pyyaml
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ostree";
  version = "2026.4";

  outputs = [
    "out"
    "dev"
    "man"
    "installedTests"
  ];

  src = fetchurl {
    url = "https://github.com/ostreedev/ostree/releases/download/v${finalAttrs.version}/libostree-${finalAttrs.version}.tar.xz";
    hash = "sha256-smyQFusDu07lLMAMZC1W4A/Hmuf6rGv0qjF9dFEznvc=";
  };

  patches = [
    ./fix-1592.patch
    (replaceVars ./fix-test-paths.patch {
      python3 = testPython.interpreter;
      openssl = "${openssl}/bin/openssl";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    glib
    gtk-doc
    which
    makeWrapper
    bison
    libxslt
    docbook_xml_dtd_42
    gobject-introspection
  ]
  ++ lib.optionals (docbook-xsl-nons != null) [ docbook-xsl-nons ];

  buildInputs = [
    curl
    glib
    e2fsprogs
    libsoup_3
    gpgme
    fuse3
    libselinux
    libsodium
    libcap
    libarchive
    bzip2
    xz
    util-linuxMinimal
    testPython
  ]
  ++ lib.optionals (withSystemd && systemd != null) [
    systemd
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-curl"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdsystemgeneratordir=${placeholder "out"}/lib/systemd/system-generators"
    "--enable-installed-tests"
    "--with-ed25519-libsodium"
  ];

  makeFlags = [
    "installed_testdir=${placeholder "installedTests"}/libexec/installed-tests/libostree"
    "installed_test_metadir=${placeholder "installedTests"}/share/installed-tests/libostree"
    "INTROSPECTION_SCANNER_ENV="
  ];

  preConfigure = ''
    env NOCONFIGURE=1 ./autogen.sh
  '';

  postFixup =
    let
      typelibPath = lib.makeSearchPath "/lib/girepository-1.0" [
        (placeholder "out")
        glib.out
      ];
    in
    ''
      for test in $installedTests/libexec/installed-tests/libostree/*.js; do
        wrapProgram "$test" --prefix GI_TYPELIB_PATH : "${typelibPath}"
      done
    '';

  meta = {
    description = "Git for operating system binaries";
    homepage = "https://ostreedev.github.io/ostree/";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.linux;
  };
})
