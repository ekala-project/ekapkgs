{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gnutls,
  gsasl,
  libidn2,
  libsecret,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "msmtp";
  version = "1.8.26";

  src = fetchurl {
    url = "https://marlam.de/msmtp/releases/msmtp-${version}.tar.xz";
    hash = "sha256-bPxIg0TO8YkmfmCupIHwDUx+Klm1PGxlnFIKTRIfZtg=";
  };

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-libgsasl"
  ];

  nativeBuildInputs = [
    pkg-config
    texinfo
  ];

  buildInputs = [
    gnutls
    gsasl
    libidn2
    libsecret
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -Dm444 -t $out/share/doc/msmtp doc/*.example
    ln -s msmtp $out/bin/sendmail
  '';

  meta = {
    description = "Simple and easy to use SMTP client with excellent sendmail compatibility";
    homepage = "https://marlam.de/msmtp/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "msmtp";
    platforms = lib.platforms.unix;
  };
}
