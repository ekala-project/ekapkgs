{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  glib,
  libxml2,
  libnl,
  systemd,
  upower,
  gtk-doc,
}:

stdenv.mkDerivation rec {
  pname = "intel-lpmd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-lpmd";
    rev = "v${version}";
    hash = "sha256-eZBgWpR2tdSDeqYV4Y2h2j5UeJebQg2tXlXcUywwZEA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
    gtk-doc
    glib
  ];

  buildInputs = [
    glib
    libxml2
    libnl
    systemd
    upower
  ];

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemdconfdir=${placeholder "out"}/etc/systemd"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
  ];

  meta = {
    description = "Intel Low Power Mode Daemon for optimizing active idle power";
    homepage = "https://github.com/intel/intel-lpmd";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "intel_lpmd";
  };
}
