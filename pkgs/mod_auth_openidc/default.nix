{
  lib,
  stdenv,
  fetchFromGitHub,
  apacheHttpd,
  apr,
  aprutil,
  autoreconfHook,
  pkg-config,
  cjose,
  curl,
  jansson,
  openssl,
  pcre,
  hiredis,
}:

stdenv.mkDerivation rec {
  pname = "mod_auth_openidc";
  version = "2.4.20.3";

  src = fetchFromGitHub {
    owner = "OpenIDC";
    repo = "mod_auth_openidc";
    tag = "v${version}";
    hash = "sha256-+BfNo71fnwVWc49726vPBVU5GsqijbelP8ouIc7UJIg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    apacheHttpd
    apr
    aprutil
    cjose
    curl
    jansson
    openssl
    pcre
    hiredis
  ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  postInstall = ''
    mkdir -p $out/lib/httpd/modules
    find $out -name "mod_auth_openidc.so" -exec mv {} $out/lib/httpd/modules/ \;
    find $out -type d -empty -delete
  '';

  meta = {
    description = "OpenID Connect Relying Party module for Apache HTTP Server";
    homepage = "https://github.com/OpenIDC/mod_auth_openidc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
