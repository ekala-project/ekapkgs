{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  systemd,
  unixtools,
  coreutils,
  wall,
  hostname,
  man,
  enableCgiScripts ? true,
  gd,
}:

assert enableCgiScripts -> gd != null;

stdenv.mkDerivation (finalAttrs: {
  pname = "apcupsd";
  version = "3.14.14";

  src = fetchurl {
    url = "mirror://sourceforge/apcupsd/apcupsd-${finalAttrs.version}.tar.gz";
    sha256 = "0rwqiyzlg9p0szf3x6q1ppvrw6f6dbpn2rc5z623fk3bkdalhxyv";
  };

  nativeBuildInputs = [
    pkg-config
    man
    unixtools.col
  ];

  buildInputs = lib.optional enableCgiScripts gd;

  prePatch = ''
    sed -e "s,\$(INSTALL_PROGRAM) \$(STRIP),\$(INSTALL_PROGRAM)," \
        -i ./src/apcagent/Makefile ./autoconf/targets.mak
  '';

  preConfigure = ''
    sed -i 's|/bin/cat|${coreutils}/bin/cat|' configure
  '';

  configureFlags = [
    "--bindir=${placeholder "out"}/bin"
    "--sbindir=${placeholder "out"}/bin"
    "--sysconfdir=${placeholder "out"}/etc/apcupsd"
    "--mandir=${placeholder "out"}/share/man"
    "--with-halpolicydir=${placeholder "out"}/share/halpolicy"
    "--localstatedir=/var"
    "--with-nologin=/run"
    "--with-log-dir=/var/log/apcupsd"
    "--with-pwrfail-dir=/run/apcupsd"
    "--with-lock-dir=/run/lock"
    "--with-pid-dir=/run"
    "--enable-usb"
    "ac_cv_path_WALL=${wall}/bin/wall"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "ac_cv_path_SHUTDOWN=${systemd}/sbin/shutdown"
  ]
  ++ lib.optionals enableCgiScripts [
    "--enable-cgi"
    "--with-cgi-bin=${placeholder "out"}/libexec/cgi-bin"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    for file in "$out"/etc/apcupsd/*; do
        sed -i -e 's|^WALL=.*|WALL="${wall}/bin/wall"|g' \
               -e 's|^HOSTNAME=.*|HOSTNAME=`${hostname}/bin/hostname`|g' \
               "$file"
    done
    rm -f "$out/bin/apcupsd-uninstall"
  '';

  meta = {
    description = "Daemon for controlling APC UPSes";
    homepage = "http://www.apcupsd.com/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
