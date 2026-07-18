{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  glib,
  libuuid,
  popt,
  elfutils,
}:

stdenv.mkDerivation rec {
  pname = "babeltrace";
  version = "1.5.11";

  src = fetchurl {
    url = "https://www.efficios.com/files/babeltrace/babeltrace-${version}.tar.bz2";
    hash = "sha256-Z7Q6qu9clR+nrxpVfPcgGhH+iYdrfCK6CgPLwxbbWpw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    glib
    pkg-config
  ];

  buildInputs = [
    glib
    libuuid
    popt
    elfutils
  ];

  configureFlags = [
    (lib.enableFeature (stdenv.hostPlatform == stdenv.buildPlatform) "debug-info")
  ];

  meta = {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = "https://www.efficios.com/babeltrace";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
