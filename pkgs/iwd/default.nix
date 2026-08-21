{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  ell,
  coreutils,
  docutils,
  readline,
  openssl,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iwd";
  version = "3.12";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    tag = finalAttrs.version;
    hash = "sha256-78Zw/i2dXecvC+DDSunPlUzqJj0FFYf7Sm6iN5VXBbA=";
  };

  patches = [
    ./no_netdev_group.diff
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ]
  ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "test";
  separateDebugInfo = true;

  nativeBuildInputs = [
    autoreconfHook
    docutils
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    ell
    python3Packages.python
    readline
  ];

  nativeCheckInputs = [ openssl ];

  pythonPath = [ ];

  configureFlags = [
    "--enable-external-ell"
    "--enable-wired"
    "--localstatedir=/var/"
    "--with-dbus-busdir=${placeholder "out"}/share/dbus-1/system-services/"
    "--with-dbus-datadir=${placeholder "out"}/share/"
    "--with-systemd-modloaddir=${placeholder "out"}/etc/modules-load.d/"
    "--with-systemd-unitdir=${placeholder "out"}/lib/systemd/system/"
    "--with-systemd-networkdir=${placeholder "out"}/lib/systemd/network/"
  ];

  postUnpack = ''
    mkdir -p iwd/ell
    ln -s ${ell.src}/ell/useful.h iwd/ell/useful.h
    ln -s ${ell.src}/ell/asn1-private.h iwd/ell/asn1-private.h
    patchShebangs .
  '';

  doCheck = true;

  postInstall = ''
    mkdir -p $doc/share/doc
    cp -a doc $doc/share/doc/iwd
    cp -a README AUTHORS TODO $doc/share/doc/iwd
  ''
  + lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    mkdir -p $test/bin
    cp -a test/* $test/bin/
  '';

  preFixup = ''
    wrapPythonPrograms
  '';

  postFixup = ''
    substituteInPlace $out/share/dbus-1/system-services/net.connman.ead.service \
      --replace-fail /bin/false ${coreutils}/bin/false
    substituteInPlace $out/share/dbus-1/system-services/net.connman.iwd.service \
      --replace-fail /bin/false ${coreutils}/bin/false
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://git.kernel.org/pub/scm/network/wireless/iwd.git";
    description = "Wireless daemon for Linux";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
