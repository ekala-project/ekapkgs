{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  aspell,
  avahi,
  cacert,
  dbus,
  dbus-glib,
  farstream,
  gettext,
  gstreamer,
  gtk2,
  gtk2-x11,
  intltool,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "pidgin";
  version = "2.14.14";

  src = fetchurl {
    url = "mirror://sourceforge/pidgin/pidgin-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-D/yZlN7xAmD5ilXNEy3u+o3EqYNUUcwOmCdHvUWOI1Y=";
  };

  nativeBuildInputs = [
    makeWrapper
    intltool
  ];

  env.NIX_CFLAGS_COMPILE = "-I${gstreamer.plugins-base.dev}/include/gstreamer-1.0";

  buildInputs =
    let
      python-with-dbus = python3.withPackages (pp: with pp; [ dbus-python ]);
    in
    [
      aspell
      avahi
      cyrus_sasl
      dbus
      dbus-glib
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
      ncurses
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
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin gtk2-x11;

  propagatedBuildInputs = [
    pkg-config
    gettext
  ]
  ++ (with perlPackages; [
    perl
    XMLParser
  ])
  ++ lib.optional stdenv.hostPlatform.isLinux gtk2
  ++ lib.optional stdenv.hostPlatform.isDarwin gtk2-x11;

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

  postInstall = ''
    wrapProgram $out/bin/pidgin \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
  '';

  meta = {
    description = "Multi-protocol instant messaging client";
    mainProgram = "pidgin";
    homepage = "https://pidgin.im/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
