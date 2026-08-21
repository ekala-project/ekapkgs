{
  lib,
  stdenv,
  fetchurl,
  glib,
  zlib,
  ncurses,
  pkg-config,
  findutils,
  systemd,
  python3,
  withAtopgpu ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atop";
  version = "2.13.0";

  src = fetchurl {
    url = "https://www.atoptool.nl/download/atop-${finalAttrs.version}.tar.gz";
    hash = "sha256-6hgvhMn1LKki5a9PF9/5f/QkQApPL5I5Mxemr2bmqHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals withAtopgpu [
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    glib
    zlib
    ncurses
  ]
  ++ lib.optionals withAtopgpu [
    python3
  ];

  pythonPath = lib.optionals withAtopgpu [
    python3.pkgs.pynvml
  ];

  makeFlags = [
    "DESTDIR=$(out)"
    "BINPATH=/bin"
    "SBINPATH=/bin"
    "MAN1PATH=/share/man/man1"
    "MAN5PATH=/share/man/man5"
    "MAN8PATH=/share/man/man8"
    "SYSDPATH=/lib/systemd/system"
    "PMPATHD=/lib/systemd/system-sleep"
  ];

  patches = [
    ./fix-paths.patch
    ./atop.service.patch
  ];

  preConfigure = ''
    for f in *.{sh,service}; do
      findutils=${findutils} systemd=${systemd} substituteAllInPlace "$f"
    done

    substituteInPlace Makefile --replace 'chown' 'true'
    substituteInPlace Makefile --replace 'chmod 04711' 'chmod 0711'
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    # Remove extra files we don't need
    rm -r $out/{var,etc} $out/bin/atop{sar,}-${finalAttrs.version}
  ''
  + (
    if withAtopgpu then
      ''
        wrapPythonPrograms
      ''
    else
      ''
        rm $out/lib/systemd/system/atopgpu.service $out/bin/atopgpud $out/share/man/man8/atopgpud.8
      ''
  );

  meta = {
    platforms = lib.platforms.linux;
    maintainers = [ ];
    description = "Console system performance monitor";
    license = lib.licenses.gpl2Plus;
    downloadPage = "http://atoptool.nl/downloadatop.php";
  };
})
