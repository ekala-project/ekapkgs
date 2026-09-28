{
  stdenv,
  fetchurl,
  makeWrapper,
  aspell,
  cacert,
  dbus,
  dbus-glib,
  farstream,
  gettext,
  glib,
  gstreamer,
  gtk2,
  intltool,
  lib,
  libice,
  libsm,
  libxscrnsaver,
  libxext,
  libgcrypt,
  libgnt,
  libidn,
  libstartup_notification,
  libxml2,
  ncurses,
  nspr,
  nss,
  perlPackages,
  pkg-config,
  python3,
  withOpenssl ? false,
  openssl,
  withGnutls ? false,
  gnutls,
  withCyrus_sasl ? true,
  cyrus_sasl,
}:

# FIXME: clean the mess around choosing the SSL library (nss by default)

stdenv.mkDerivation rec {
  pname = "pidgin";
  version = "2.14.14";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/pidgin-${version}.tar.bz2";
    sha256 = "sha256-D/yZlN7xAmD5ilXNEy3u+o3EqYNUUcwOmCdHvUWOI1Y=";
  };

  nativeBuildInputs = [
    makeWrapper
    intltool
    pkg-config
  ];

  env.NIX_CFLAGS_COMPILE = "-I${gstreamer.plugins-base.dev}/include/gstreamer-1.0";

  buildInputs =
    let
      python-with-dbus = python3.withPackages (pp: with pp; [ dbus-python ]);
    in
    [
      aspell
      cyrus_sasl
      dbus
      dbus-glib
      glib
      gstreamer.plugins-base
      gstreamer.plugins-good
      gstreamer
      libice
      libsm
      libxscrnsaver
      libxext
      libgnt
      libidn
      libstartup_notification
      libxml2
      ncurses # optional: build finch - the console UI
      nspr
      nss
      python-with-dbus
    ]
    ++ lib.optional withOpenssl openssl
    ++ lib.optionals withGnutls [
      gnutls
      libgcrypt
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk2
      farstream
    ];

  propagatedBuildInputs = [
    gettext
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ])
  ++ lib.optional stdenv.hostPlatform.isLinux gtk2;

  patches = [
    ./add-search-path.patch
    ./pidgin-makefile.patch
  ];

  configureFlags = [
    "--with-nspr-includes=${nspr.dev}/include/nspr"
    "--with-nspr-libs=${nspr.out}/lib"
    "--with-nss-includes=${nss.dev}/include/nss"
    "--with-nss-libs=${nss.out}/lib"
    "--with-ncurses-headers=${ncurses.dev}/include"
    "--with-system-ssl-certs=${cacert}/etc/ssl/certs"
    "--disable-avahi"
    "--disable-meanwhile"
    "--disable-nm"
    "--disable-tcl"
    "--disable-gevolution"
    "--disable-gtkspell"
  ]
  ++ lib.optionals withCyrus_sasl [ "--enable-cyrus-sasl=yes" ]
  ++ lib.optionals withGnutls [
    "--enable-gnutls=yes"
    "--enable-nss=no"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "--disable-vv" ]
  ++ lib.optionals stdenv.cc.isClang [ "CFLAGS=-Wno-error=int-conversion" ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/pidgin \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  doInstallCheck = false;

  passthru = {
    makePluginPath = lib.makeSearchPathOutput "lib" "lib/purple-${lib.versions.major version}";
  };

  meta = {
    description = "Multi-protocol instant messaging client";
    mainProgram = "pidgin";
    homepage = "https://pidgin.im/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
