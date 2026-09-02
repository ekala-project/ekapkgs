{
  bzip2,
  fetchurl,
  glib,
  gperf,
  gtk3,
  judy,
  lib,
  pkg-config,
  stdenv,
  tcl,
  tk,
  wrapGAppsHook3,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtkwave";
  version = "3.3.128";

  src = fetchurl {
    url = "mirror://sourceforge/gtkwave/gtkwave-gtk3-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-gX4Zf8GAj4qsNUPCwvloPLATaMkRkrjq5a9YBw7x0fg=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    bzip2
    glib
    gperf
    gtk3
    judy
    tcl
    tk
    xz
  ];

  configureFlags = [
    "--with-tcl=${tcl}/lib"
    "--with-tk=${tk}/lib"
    "--enable-judy"
    "--enable-gtk3"
  ];

  meta = {
    description = "VCD/Waveform viewer for Unix and Win32";
    homepage = "https://gtkwave.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
