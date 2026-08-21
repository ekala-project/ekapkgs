{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  perl,
  gperf,
  bison,
  flex,
  gmp,
  python3,
  iptables,
  ldns,
  unbound,
  openssl,
  pcsclite,
  systemd,
  pam,
  curl,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "strongswan";
  version = "5.9.14";

  src = fetchFromGitHub {
    owner = "strongswan";
    repo = "strongswan";
    rev = version;
    hash = "sha256-qFM7ErfqiDlUsZdGXJQVW3nJoh+I6tEdKRwzrKteRVY=";
  };

  dontPatchELF = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    perl
    gperf
    bison
    flex
  ];

  buildInputs = [
    curl
    gmp
    python3
    ldns
    unbound
    openssl
    pcsclite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemd.dev
    pam
    iptables
  ];

  patches = [
    ./ext_auth-path.patch
    ./firewall_defaults.patch
    ./updown-path.patch
  ];

  ACLOCAL_PATH = "${gettext}/share/gettext/m4";

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    # glibc-2.26 reorganized internal includes
    sed '1i#include <stdint.h>' -i src/libstrongswan/utils/utils/memory.h
  '';

  configureFlags = [
    "--sysconfdir=/etc"
    "--enable-swanctl"
    "--enable-cmd"
    "--enable-openssl"
    "--enable-eap-sim"
    "--enable-eap-sim-file"
    "--enable-eap-simaka-pseudonym"
    "--enable-eap-simaka-reauth"
    "--enable-eap-identity"
    "--enable-eap-md5"
    "--enable-eap-gtc"
    "--enable-eap-aka"
    "--enable-eap-aka-3gpp2"
    "--enable-eap-mschapv2"
    "--enable-eap-radius"
    "--enable-xauth-eap"
    "--enable-ext-auth"
    "--enable-acert"
    "--enable-pkcs11"
    "--enable-eap-sim-pcsc"
    "--enable-dnscert"
    "--enable-unbound"
    "--enable-chapoly"
    "--enable-curl"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--enable-farp"
    "--enable-dhcp"
    "--enable-systemd"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "--enable-xauth-pam"
    "--enable-forecast"
    "--enable-connmark"
    "--enable-af-alg"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    "--enable-aesni"
    "--enable-rdrand"
  ]
  ++ lib.optional (stdenv.hostPlatform.system == "i686-linux") "--enable-padlock";

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  NIX_LDFLAGS = lib.optionalString stdenv.cc.isGNU "-lgcc_s";

  meta = {
    description = "OpenSource IPsec-based VPN Solution";
    homepage = "https://www.strongswan.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
