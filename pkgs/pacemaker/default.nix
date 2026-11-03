{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  bash,
  bzip2,
  corosync,
  dbus,
  docbook_xsl,
  getopt,
  gettext,
  glib,
  gnutls,
  help2man,
  libqb,
  libtool,
  libuuid,
  libxml2,
  libxslt,
  pam,
  pkg-config,
  python3,
  forOCF ? false,
  ocf-resource-agents ? null,
  withManpages ? !forOCF,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacemaker";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ClusterLabs";
    repo = "pacemaker";
    tag = "Pacemaker-${finalAttrs.version}";
    hash = "sha256-23YkNzqiimLy/KjO+hxVQQ4rUhSEhn5Oc2jUJO/VRo0=";
  };

  outputs = [ "out" ] ++ lib.optionals withManpages [ "man" ];

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    getopt
    libtool
    pkg-config
    python3
  ]
  ++ lib.optionals withManpages [
    help2man
    libxml2
    libxslt
  ];

  buildInputs = [
    bash
    bzip2
    corosync
    dbus
    glib
    gnutls
    libqb
    libtool
    libuuid
    libxml2
    libxslt
    pam
  ];

  strictDeps = true;

  postPatch = lib.optionalString withManpages ''
    substituteInPlace configure.ac \
      --replace-fail 'MANPAGE_XSLT=""' 'MANPAGE_XSLT="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"' \
      --replace-fail 'AS_IF([test x"''${XSLTPROC}" != x""],' 'AS_IF([false],'
  '';

  preConfigure = ''
    ./autogen.sh --prefix="$out"
  '';

  configureFlags = [
    "--exec-prefix=${placeholder "out"}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-initdir=/etc/systemd/system"
    "--with-systemdsystemunitdir=/etc/systemd/system"
    "--with-corosync"
    "--enable-systemd"
  ]
  ++ lib.optional (
    !forOCF && ocf-resource-agents != null
  ) "--with-ocfdir=${ocf-resource-agents}/usr/lib/ocf";

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isGNU [
      "-Wno-error=strict-prototypes"
      "-Wno-error=deprecated-declarations"
    ]
    ++ [
      "-Wno-error=discarded-qualifiers"
    ]
  );

  postInstall =
    lib.optionalString withManpages ''
      mkdir -p $man
      mv $out$man/* $man
    ''
    + ''
      mv $out$out/* $out
      rm -r $out/nix
    '';

  meta = {
    homepage = "https://clusterlabs.org/pacemaker/";
    description = "Open source, high availability resource manager suitable for both small and large clusters";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
