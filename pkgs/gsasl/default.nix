{
  fetchurl,
  lib,
  stdenv,
  libidn,
  libkrb5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gsasl";
  version = "2.2.2";

  src = fetchurl {
    url = "mirror://gnu/gsasl/gsasl-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-QejkQmSOzK9kWdmtk9SxhTC5bI6vUOPzQlMu8nXv87o=";
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
