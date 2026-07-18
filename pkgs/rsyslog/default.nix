{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoreconfHook,
  libestr,
  json_c,
  zlib,
  docutils,
  libfastjson,
  libkrb5,
  systemd,
  jemalloc,
  libdbi,
  net-snmp,
  libuuid,
  curl,
  gnutls,
  libgcrypt,
  liblognorm,
  libmaxminddb,
  openssl,
  librelp,
  libnet,
  rdkafka,
  rabbitmq-c,
  hiredis,
}:

stdenv.mkDerivation rec {
  pname = "rsyslog";
  version = "8.2504.0";

  src = fetchurl {
    url = "https://www.rsyslog.com/files/download/rsyslog/${pname}-${version}.tar.gz";
    hash = "sha256-UJKiDtQJh8dMxgTr/NbHSeR+ufw0rcHCY35lU+fwR6s=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    docutils
  ];

  buildInputs = [
    libfastjson
    libestr
    json_c
    zlib
    libkrb5
    jemalloc
    libdbi
    net-snmp
    libuuid
    curl
    gnutls
    libgcrypt
    liblognorm
    libmaxminddb
    openssl
    librelp
    libnet
    rdkafka
    rabbitmq-c
    hiredis
    systemd
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    (lib.enableFeature true "largefile")
    (lib.enableFeature true "regexp")
    (lib.enableFeature true "gssapi-krb5")
    (lib.enableFeature true "klog")
    (lib.enableFeature true "kmsg")
    (lib.enableFeature true "imjournal")
    (lib.enableFeature true "inet")
    (lib.enableFeature true "jemalloc")
    (lib.enableFeature true "unlimited-select")
    (lib.enableFeature true "clickhouse")
    (lib.enableFeature false "debug")
    (lib.enableFeature false "debug-symbols")
    (lib.enableFeature true "debugless")
    (lib.enableFeature false "valgrind")
    (lib.enableFeature false "diagtools")
    (lib.enableFeature true "fmhttp")
    (lib.enableFeature true "usertools")
    (lib.enableFeature false "mysql")
    (lib.enableFeature false "pgsql")
    (lib.enableFeature true "libdbi")
    (lib.enableFeature true "snmp")
    (lib.enableFeature true "uuid")
    (lib.enableFeature true "elasticsearch")
    (lib.enableFeature true "gnutls")
    (lib.enableFeature true "libgcrypt")
    (lib.enableFeature true "rsyslogrt")
    (lib.enableFeature true "rsyslogd")
    (lib.enableFeature true "mail")
    (lib.enableFeature true "mmnormalize")
    (lib.enableFeature true "mmdblookup")
    (lib.enableFeature true "mmjsonparse")
    (lib.enableFeature true "mmaudit")
    (lib.enableFeature true "mmanon")
    (lib.enableFeature true "mmutf8fix")
    (lib.enableFeature true "mmcount")
    (lib.enableFeature true "mmsequence")
    (lib.enableFeature true "mmfields")
    (lib.enableFeature true "mmpstrucdata")
    (lib.enableFeature true "mmrfc5424addhmac")
    (lib.enableFeature true "relp")
    (lib.enableFeature false "ksi-ls12")
    (lib.enableFeature false "liblogging-stdlog")
    (lib.enableFeature false "rfc3195")
    (lib.enableFeature true "imfile")
    (lib.enableFeature false "imsolaris")
    (lib.enableFeature true "imptcp")
    (lib.enableFeature true "impstats")
    (lib.enableFeature true "omprog")
    (lib.enableFeature true "omudpspoof")
    (lib.enableFeature true "omstdout")
    (lib.enableFeature true "omjournal")
    (lib.enableFeature true "pmlastmsg")
    (lib.enableFeature true "pmcisconames")
    (lib.enableFeature true "pmciscoios")
    (lib.enableFeature true "pmaixforwardedfrom")
    (lib.enableFeature true "pmsnare")
    (lib.enableFeature true "omruleset")
    (lib.enableFeature true "omuxsock")
    (lib.enableFeature true "mmsnmptrapd")
    (lib.enableFeature false "omhdfs")
    (lib.enableFeature true "omkafka")
    (lib.enableFeature false "ommongodb")
    (lib.enableFeature false "imczmq")
    (lib.enableFeature false "omczmq")
    (lib.enableFeature true "omrabbitmq")
    (lib.enableFeature true "omhiredis")
    (lib.enableFeature true "omhttp")
    (lib.enableFeature true "generate-man-pages")
  ];

  meta = {
    homepage = "https://www.rsyslog.com/";
    description = "Enhanced syslog implementation";
    mainProgram = "rsyslogd";
    changelog = "https://raw.githubusercontent.com/rsyslog/rsyslog/v${version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
