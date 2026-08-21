{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  fetchpatch,
  wafHook,
  pkg-config,
  bison,
  flex,
  perl,
  libxslt,
  docbook_xsl,
  docbook_xml_dtd_45,
  readline,
  popt,
  dbus,
  libbsd,
  libarchive,
  zlib,
  liburing,
  gnutls,
  systemd,
  talloc,
  jansson,
  ldb,
  libtasn1,
  tdb,
  tevent,
  libxcrypt,
  libxcrypt-legacy,
  cmocka,
  rpcsvc-proto,
  bash,
  python3Packages,
  libiconv,

  enableLDAP ? false,
  openldap,
  enablePrinting ? false,
  cups,
  enableProfiling ? true,
  enableMDNS ? false,
  avahi,
  enableDomainController ? false,
  gpgme,
  lmdb,
  enableRegedit ? true,
  ncurses,
  enableCephFS ? false,
  enableGlusterFS ? false,
  libuuid,
  enableAcl ? (!stdenv.hostPlatform.isDarwin),
  acl,
  enableLibunwind ? (!stdenv.hostPlatform.isDarwin),
  libunwind,
  enablePam ? (!stdenv.hostPlatform.isDarwin),
  pam,
}:

let
  # samba-tool requires libxcrypt-legacy algorithms
  python = python3Packages.python.override {
    self = python;
    libxcrypt = libxcrypt-legacy;
  };
  wrapPython = python3Packages.wrapPython.override {
    inherit python;
  };

  inherit (lib) optional optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "samba";
  version = "4.20.8";

  src = fetchurl {
    url = "https://download.samba.org/pub/samba/stable/samba-${finalAttrs.version}.tar.gz";
    hash = "sha256-db4OjTH0UBPpsmD+fPMEo20tgSg5GRR3JXchXsFzqAc=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  patches = [
    ./4.x-no-persistent-install.patch
    ./patch-source3__libads__kerberos_keytab.c.patch
    ./4.x-no-persistent-install-dynconfig.patch
    ./4.x-fix-makeflags-parsing.patch
    ./build-find-pre-built-heimdal-build-tools-in-case-of-.patch
    (fetchpatch {
      # workaround for https://github.com/NixOS/nixpkgs/issues/303436
      name = "samba-reproducible-builds.patch";
      url = "https://gitlab.com/raboof/samba/-/commit/9995c5c234ece6888544cdbe6578d47e83dea0b5.patch";
      hash = "sha256-TVKK/7wGsfP1pVf8o1NwazobiR8jVJCCMj/FWji3f2A=";
    })
  ];

  nativeBuildInputs = [
    python3Packages.python
    wafHook
    pkg-config
    bison
    flex
    perl
    perl.pkgs.ParseYapp
    perl.pkgs.JSON
    libxslt
    docbook_xsl
    docbook_xml_dtd_45
    cmocka
    rpcsvc-proto
  ]
  ++ optionals stdenv.hostPlatform.isLinux [
    buildPackages.stdenv.cc
  ];

  wafPath = "buildtools/bin/waf";

  buildInputs = [
    bash
    wrapPython
    python
    readline
    popt
    dbus
    jansson
    libbsd
    libarchive
    zlib
    gnutls
    libtasn1
    tdb
    libxcrypt
  ]
  ++ optionals stdenv.hostPlatform.isLinux [
    liburing
    systemd
  ]
  ++ optionals stdenv.hostPlatform.isDarwin [ libiconv ]
  ++ optionals enableLDAP [
    openldap.dev
    python3Packages.markdown
  ]
  ++ optionals (!enableLDAP && stdenv.hostPlatform.isLinux) [
    ldb
    talloc
    tevent
  ]
  ++ optional enablePrinting cups
  ++ optional enableMDNS avahi
  ++ optionals enableDomainController [
    gpgme
    lmdb
    python3Packages.dnspython
  ]
  ++ optional enableRegedit ncurses
  ++ optionals (enableGlusterFS && stdenv.hostPlatform.isLinux) [
    libuuid
  ]
  ++ optional enableAcl acl
  ++ optional enableLibunwind libunwind
  ++ optional enablePam pam;

  postPatch = ''
    # Removes absolute paths in scripts
    sed -i 's,/sbin/,,g' ctdb/config/functions

    # Fix the XML Catalog Paths
    sed -i "s,\(XML_CATALOG_FILES=\"\),\1$XML_CATALOG_FILES ,g" buildtools/wafsamba/wafsamba.py

    patchShebangs ./buildtools/bin
  '';

  preConfigure = ''
    export PKGCONFIG="$PKG_CONFIG"
    export PYTHONHASHSEED=1
  '';

  wafConfigureFlags = [
    "--with-static-modules=NONE"
    "--with-shared-modules=ALL"
    "--enable-fhs"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--disable-rpath"
    "--pythondir=${placeholder "out"}/${python.sitePackages}"
    (lib.enableFeature enablePrinting "cups")
  ]
  ++ optional (!enableDomainController) "--without-ad-dc"
  ++ optionals (!enableLDAP) [
    "--without-ldap"
    "--without-ads"
  ]
  ++ optionals (!enableLDAP && stdenv.hostPlatform.isLinux) [
    "--bundled-libraries=!ldb,!pyldb-util!talloc,!pytalloc-util,!tevent,!tdb,!pytdb"
  ]
  ++ optional enableLibunwind "--with-libunwind"
  ++ optional enableProfiling "--with-profiling-data"
  ++ optional (!enableAcl) "--without-acl-support"
  ++ optional (!enablePam) "--without-pam"
  ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--bundled-libraries=!asn1_compile,!compile_et"
    "--cross-compile"
    "--cross-execute=${stdenv.hostPlatform.emulator buildPackages}"
  ]
  ++ optionals stdenv.buildPlatform.is32bit [
    "--jobs 1"
  ];

  # python-config from build Python gives incorrect values when cross-compiling.
  PYTHON_CONFIG = "/invalid";

  pythonPath = [
    python3Packages.dnspython
    python3Packages.markdown
    tdb
  ];

  preBuild = ''
    export MAKEFLAGS="-j $NIX_BUILD_CORES"
  '';

  # Save asn1_compile and compile_et so they are available to run on the build
  # platform when cross-compiling
  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p "$dev/bin"
    cp bin/asn1_compile bin/compile_et "$dev/bin"
  '';

  # Some libraries don't have /lib/samba in RPATH but need it.
  postFixup = ''
    export SAMBA_LIBS="$(find $out -type f -regex '.*\${stdenv.hostPlatform.extensions.sharedLibrary}\(\..*\)?' -exec dirname {} \; | sort | uniq)"
    read -r -d "" SCRIPT << EOF || true
    [ -z "\$SAMBA_LIBS" ] && exit 1;
    BIN='{}';
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    OLD_LIBS="\$(patchelf --print-rpath "\$BIN" 2>/dev/null | tr ':' '\n')";
    ALL_LIBS="\$(echo -e "\$SAMBA_LIBS\n\$OLD_LIBS" | sort | uniq | tr '\n' ':')";
    patchelf --set-rpath "\$ALL_LIBS" "\$BIN" 2>/dev/null || exit $?;
    patchelf --shrink-rpath "\$BIN";
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -id \$BIN \$BIN
    for old_rpath in \$(otool -L \$BIN | grep /private/tmp/ | awk '{print \$1}'); do
      new_rpath=\$(find \$SAMBA_LIBS -name \$(basename \$old_rpath) | head -n 1)
      install_name_tool -change \$old_rpath \$new_rpath \$BIN
    done
  ''
  + ''
    EOF
    find $out -type f -regex '.*\${stdenv.hostPlatform.extensions.sharedLibrary}\(\..*\)?' -exec $SHELL -c "$SCRIPT" \;
    find $out/bin -type f -exec $SHELL -c "$SCRIPT" \;

    # Fix PYTHONPATH for some tools
    wrapPythonPrograms

    # Samba does its own shebang patching, but uses build Python
    find $out/bin -type f -executable | while read file; do
      isScript "$file" || continue
      sed -i 's^${lib.getBin buildPackages.python3Packages.python}^${lib.getBin python}^' "$file"
    done
  '';

  disallowedReferences = lib.optionals (
    buildPackages.python3Packages.python != python3Packages.python
  ) [ buildPackages.python3Packages.python ];

  meta = {
    homepage = "https://www.samba.org";
    description = "Standard Windows interoperability suite of programs for Linux and Unix";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
