{
  lib,
  stdenv,
  autoreconfHook,
  avahi,
  coreutils,
  fetchurl,
  freeipmi,
  gd,
  i2c-tools,
  libgpiod ? null,
  libmodbus,
  libtool,
  libusb1,
  makeWrapper,
  neon,
  net-snmp,
  openssl,
  pkg-config,
  replaceVars,
  systemd,
  udev,
  gnused,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nut";
  version = "2.8.4";

  src = fetchurl {
    url = "https://networkupstools.org/source/${lib.versions.majorMinor finalAttrs.version}/nut-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-ATC6gup58Euk80xSSahZQ5d+/ZhO199q7BpRjVo1lPg=";
  };

  patches = [
    ./nutshutdown-conf-default.patch

    (replaceVars ./hardcode-paths.patch {
      avahi = "${avahi}/lib";
      freeipmi = "${freeipmi}/lib";
      libgpiod = if libgpiod != null then "${libgpiod}/lib" else "/homeless-shelter";
      libusb = "${libusb1}/lib";
      neon = "${neon}/lib";
      libmodbus = "${libmodbus}/lib";
      netsnmp = "${net-snmp.lib}/lib";
    })
  ];

  buildInputs = [
    avahi
    freeipmi
    gd
    i2c-tools
    libtool
    libusb1
    libmodbus
    neon
    net-snmp
    openssl
    udev
  ]
  ++ lib.optional (libgpiod != null) libgpiod;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    makeWrapper
  ];

  doInstallCheck = true;

  configureFlags = [
    "--enable-docs-changelog=no"
    "--with-all"
    "--with-ssl"
    "--without-powerman"
    "--with-pynut=app"
    "--with-systemdsystempresetdir=$(out)/lib/systemd/system-preset"
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system"
    "--with-systemdshutdowndir=$(out)/lib/systemd/system-shutdown"
    "--with-systemdtmpfilesdir=$(out)/lib/tmpfiles.d"
    "--with-udev-dir=$(out)/etc/udev"
    "--with-user=nutmon"
    "--with-group=nutmon"
  ];

  enableParallelBuilding = true;

  stripDebugList = [
    "cgi-bin"
    "lib"
    "lib32"
    "lib64"
    "libexec"
    "bin"
    "sbin"
  ];

  postInstall = ''
    substituteInPlace $out/lib/systemd/system-shutdown/nutshutdown \
      --replace /bin/sed "${gnused}/bin/sed" \
      --replace /bin/sleep "${coreutils}/bin/sleep" \
      --replace /bin/systemctl "${systemd}/bin/systemctl"

    for file in system/{nut-monitor.service,nut-driver-enumerator.service,nut-server.service,nut-driver@.service} system-shutdown/nutshutdown; do
      substituteInPlace $out/lib/systemd/$file \
        --replace "$out/etc/nut.conf" "/etc/nut/nut.conf"
    done

    substituteInPlace $out/lib/systemd/system/nut-driver-enumerator.path \
      --replace "$out/etc/ups.conf" "/etc/nut/ups.conf"

    # Suspicious/overly broad rule, remove it until we know better
    rm $out/etc/udev/rules.d/52-nut-ipmipsu.rules
  '';

  meta = {
    description = "Network UPS Tools";
    longDescription = ''
      Network UPS Tools is a collection of programs which provide a common
      interface for monitoring and administering UPS, PDU and SCD hardware.
      It uses a layered approach to connect all of the parts.
    '';
    homepage = "https://networkupstools.org/";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      gpl1Plus
      gpl2Plus
      gpl3Plus
    ];
    priority = 10;
  };
})
