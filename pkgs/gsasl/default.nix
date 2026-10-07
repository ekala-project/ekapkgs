{
  fetchurl,
  lib,
  stdenv,
  libidn,
  libkrb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsasl";
  version = "2.2.4";

  src = fetchurl {
    url = "mirror://gnu/gsasl/gsasl-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-0yvhXv06BMsZsjL3Ib3KAsxq16tBXffXn7LdLA2j4L4=";
  };

  buildInputs = [
    libidn
    libkrb5
  ];

  configureFlags = [ "--with-gssapi-impl=mit" ];

  preCheck = ''
    export LOCALDOMAIN="dummydomain"
  '';
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "GNU SASL, Simple Authentication and Security Layer library";
    mainProgram = "gsasl";
    homepage = "https://www.gnu.org/software/gsasl/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
