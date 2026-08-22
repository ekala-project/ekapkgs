{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  libzip,
  glib,
  libusb1,
  libftdi1,
  check,
  libserialport,
  doxygen,
  glibmm,
  python3,
  hidapi,
  libieee1284,
  bluez,
  sigrok-firmware-fx2lafw ? null,
  fetchgit,
}:
stdenv.mkDerivation {
  pname = "libsigrok";
  version = "0.6.0-unstable-2025-11-20";

  src = fetchgit {
    url = "git://sigrok.org/libsigrok";
    rev = "0bc2487778e660f4d3116729b6f4aee2b1996bb0";
    hash = "sha256-j79Wx5FFFKptcwtIjQ0Cvtzl46lnow6bExpMNzI8KlM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    doxygen
    pkg-config
    python3
  ];
  buildInputs = [
    libzip
    glib
    libusb1
    libftdi1
    check
    libserialport
    glibmm
    hidapi
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libieee1284
    bluez
  ];

  strictDeps = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp contrib/*.rules $out/etc/udev/rules.d
  ''
  + lib.optionalString (sigrok-firmware-fx2lafw != null) ''
    mkdir -p "$out/share/sigrok-firmware/"
    cp ${sigrok-firmware-fx2lafw}/share/sigrok-firmware/* "$out/share/sigrok-firmware/"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    [[ -f $out/include/libsigrokcxx/libsigrokcxx.hpp ]] \
      || { echo 'C++ bindings were not generated; check configure output'; false; }

    runHook postInstallCheck
  '';

  meta = {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
