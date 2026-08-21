{
  lib,
  stdenv,
  fetchurl,
  file,
  openssl,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "net-snmp";
  version = "5.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/net-snmp/${pname}-${version}.tar.gz";
    sha256 = "sha256-i03gE5HnTjxwFL60OWGi1tb6A6zDQoC5WF9JMHRbBUQ=";
  };

  outputs = [
    "bin"
    "out"
    "dev"
    "lib"
  ];

  configureFlags = [
    "--with-default-snmp-version=3"
    "--with-sys-location=Unknown"
    "--with-sys-contact=root@unknown"
    "--with-logfile=/var/log/net-snmpd.log"
    "--with-persistent-directory=/var/lib/net-snmp"
    "--with-openssl=${openssl.dev}"
    "--disable-embedded-perl"
    "--without-perl-modules"
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux "--with-mnttab=/proc/mounts";

  postConfigure = ''
    # libraries contain configure options. Mangle store paths out from
    # ./configure-generated file.
    sed -i include/net-snmp/net-snmp-config.h \
      -e "/NETSNMP_CONFIGURE_OPTIONS/ s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g"
  '';

  nativeBuildInputs = [
    file
    autoreconfHook
  ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;
  enableParallelInstalling = false;
  doCheck = false;

  postInstall = ''
    for f in "$lib/lib/"*.la $bin/bin/net-snmp-config $bin/bin/net-snmp-create-v3-user; do
      sed 's|-L${openssl.dev}|-L${lib.getLib openssl}|g' -i $f
    done
    mkdir $dev/bin
    mv $bin/bin/net-snmp-config $dev/bin
  '';

  meta = {
    description = "Clients and server for the SNMP network monitoring protocol";
    homepage = "http://www.net-snmp.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
