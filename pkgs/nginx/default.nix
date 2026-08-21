{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  pcre2,
  libxml2,
  libxslt,
  perl,
  installShellFiles,
  removeReferencesTo,
  withStream ? true,
  withPerl ? true,
}:

stdenv.mkDerivation rec {
  pname = "nginx";
  version = "1.28.0";

  src = fetchurl {
    url = "https://nginx.org/download/nginx-${version}.tar.gz";
    hash = "sha256-xrXGsIbA3508o/9eCEwdDvkJ5gOCecccHD6YX1dv92o=";
  };

  nativeBuildInputs = [
    installShellFiles
    removeReferencesTo
  ];

  buildInputs = [
    openssl
    zlib
    pcre2
    libxml2
    libxslt
    perl
  ];

  patches = [
    ./nix-etag-1.15.4.patch
    ./nix-skip-check-logs-path.patch
  ];

  postPatch = ''
    substituteInPlace src/http/ngx_http_core_module.c \
      --replace-fail '@nixStoreDir@' "$NIX_STORE" \
      --replace-fail '@nixStoreDirLen@' "''${#NIX_STORE}"
  '';

  configureFlags = [
    "--sbin-path=bin/nginx"
    "--with-http_ssl_module"
    "--with-http_v2_module"
    "--with-http_realip_module"
    "--with-http_addition_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_flv_module"
    "--with-http_mp4_module"
    "--with-http_gunzip_module"
    "--with-http_gzip_static_module"
    "--with-http_auth_request_module"
    "--with-http_random_index_module"
    "--with-http_secure_link_module"
    "--with-http_degradation_module"
    "--with-http_stub_status_module"
    "--with-threads"
    "--with-pcre-jit"
    "--http-log-path=/var/log/nginx/access.log"
    "--error-log-path=/var/log/nginx/error.log"
    "--pid-path=/var/log/nginx/nginx.pid"
    "--http-client-body-temp-path=/tmp/nginx_client_body"
    "--http-proxy-temp-path=/tmp/nginx_proxy"
    "--http-fastcgi-temp-path=/tmp/nginx_fastcgi"
    "--http-uwsgi-temp-path=/tmp/nginx_uwsgi"
    "--http-scgi-temp-path=/tmp/nginx_scgi"
  ]
  ++ lib.optionals withStream [
    "--with-stream"
    "--with-stream_realip_module"
    "--with-stream_ssl_module"
    "--with-stream_ssl_preread_module"
  ]
  ++ lib.optionals withPerl [
    "--with-http_perl_module"
    "--with-perl=${perl}/bin/perl"
    "--with-perl_modules_path=lib/perl5"
  ]
  ++ lib.optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio";

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${libxml2.dev}/include/libxml2"
    "-Wno-error=implicit-fallthrough"
  ];

  configurePlatforms = [ ];

  preConfigure = ''
    setOutputFlags=
  '';

  hardeningEnable = lib.optional (!stdenv.hostPlatform.isDarwin) "pie";

  enableParallelBuilding = true;

  preInstall = ''
    if [[ -e man/nginx.8 ]]; then
      installManPage man/nginx.8
    fi
  '';

  meta = {
    description = "Reverse proxy and lightweight webserver";
    mainProgram = "nginx";
    homepage = "http://nginx.org";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
