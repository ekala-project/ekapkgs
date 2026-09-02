{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  curl,
  apacheHttpd,
  pcre2,
  apr,
  aprutil,
  libxml2,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "modsecurity";
  version = "2.9.12";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "modsecurity";
    tag = "v${finalAttrs.version}";
    hash = "sha256-scMOiu8oI3+VcXe05gLNQ8ILmnP4iwls8ZZ9r+3ei5Y=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    curl
    apacheHttpd
    pcre2
    apr
    aprutil
    libxml2
  ];

  configureFlags = [
    "--enable-standalone-module"
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-pcre2=${lib.getDev pcre2}/bin/pcre2-config"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
    "--with-lua=no"
  ];

  enableParallelBuilding = true;

  outputs = [
    "out"
    "nginx"
  ];
  patches = [
    # by default modsecurity's install script copies compiled output to httpd's modules folder
    # this patch removes those lines
    ./Makefile.am.patch
  ];

  doCheck = true;
  nativeCheckInputs = [ perl ];

  postInstall = ''
    mkdir -p $nginx
    cp -R * $nginx
  '';

  meta = {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = lib.licenses.asl20;
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    platforms = lib.platforms.linux;
  };
})
