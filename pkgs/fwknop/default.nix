{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libpcap,
  texinfo,
  iptables,
  gnupg,
  gpgme,
  wget,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fwknop";
  version = "2.6.11";

  src = fetchFromGitHub {
    owner = "mrash";
    repo = "fwknop";
    tag = finalAttrs.version;
    hash = "sha256-jnEBRJCt7pAmXRIBVT2OwJqT5Zr/JaRgPDqccx0W/9o=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    libpcap
    texinfo
    gnupg
    gpgme.dev
    wget
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/run"
    "--with-iptables=${iptables}/sbin/iptables"
    "--enable-server"
    "--enable-client"
    "--with-gpgme"
    "--with-gpgme-prefix=${gpgme.dev}"
    "--with-gpg=${gnupg}"
    "--with-wget=${wget}/bin/wget"
  ];

  # Copy the example configuration files into the nix store
  preInstall = ''
    substituteInPlace Makefile --replace-fail \
      "sysconfdir = /etc"\
      "sysconfdir = $out/etc"
    substituteInPlace server/Makefile --replace-fail \
      "wknopddir = /etc/fwknop"\
      "wknopddir = $out/etc/fwknop"
  '';

  meta = {
    description = "Single Packet Authorization (and Port Knocking) server/client";
    homepage = "https://www.cipherdyne.org/fwknop/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
