{
  lib,
  stdenv,
  fetchFromGitHub,
  apacheHttpd,
  autoreconfHook,
  pkg-config,
  bison,
  flex,
  krb5,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "mod_auth_gssapi";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "gssapi";
    repo = "mod_auth_gssapi";
    tag = "v${version}";
    hash = "sha256-DEyQjU7vfipmNB9oU/JwkM/LdMOtnYE/bFCutMyalDo=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    krb5
    openssl
  ];

  configureFlags = [
    "--with-apxs2=${apacheHttpd.dev}/bin/apxs"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  postInstall = ''
    mkdir -p $out/lib/httpd/modules
    find $out -name "mod_auth_gssapi.so" -exec mv {} $out/lib/httpd/modules/ \;
    find $out -type d -empty -delete
  '';

  meta = {
    description = "GSSAPI authentication module for Apache HTTP Server";
    homepage = "https://github.com/gssapi/mod_auth_gssapi";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
