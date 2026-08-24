{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  replaceVars,
  plymouth,
  pam,
  pkg-config,
  autoreconfHook,
  gettext,
  libtool,
  libxcb,
  glib,
  libxdmcp,
  itstool,
  intltool,
  libxklavier,
  libgcrypt,
  audit,
  busybox,
  polkit,
  accountsservice,
  gtk-doc,
  gobject-introspection,
  vala,
  yelp-tools,
  yelp-xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lightdm";
  version = "1.33.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "ubuntu";
    repo = "lightdm";
    tag = finalAttrs.version;
    sha256 = "sha256-/p5/V2KNRkm1cP9/Ld3crfAxAdHYc2mFyNl1rV6QXr0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    yelp-tools
    yelp-xsl
    gobject-introspection
    gtk-doc
    intltool
    itstool
    libtool
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    audit
    glib
    libxdmcp
    libgcrypt
    libxcb
    libxklavier
    pam
    polkit
  ];

  patches = [
    # Hardcode plymouth to fix transitions.
    (replaceVars ./fix-paths.patch {
      plymouth = "${plymouth}/bin/plymouth";
    })

    # glib gettext is deprecated and broken, so use regular gettext instead
    ./use-regular-gettext.patch
  ];

  dontWrapQtApps = true;

  preConfigure = "NOCONFIGURE=1 ./autogen.sh";

  configureFlags = [
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--disable-tests"
    "--disable-dmrc"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
    "localstatedir=\${TMPDIR}"
  ];

  prePatch = ''
    substituteInPlace autogen.sh \
      --replace "which" "${buildPackages.busybox}/bin/which"

    substituteInPlace src/shared-data-manager.c \
      --replace /bin/rm ${busybox}/bin/rm
  '';

  postInstall = ''
    rm -rf $out/etc/apparmor.d $out/etc/init $out/etc/pam.d
  '';

  meta = {
    homepage = "https://github.com/ubuntu/lightdm";
    description = "Cross-desktop display manager";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3Plus
      lgpl2Only
      lgpl3Only
    ];
    maintainers = [ ];
  };
})
