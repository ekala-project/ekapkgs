{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  perl,
  zlib,
  apr,
  aprutil,
  pcre2,
  libiconv,
  which,
  libxcrypt,
  buildPackages,
  openssl,
  libxml2,
  openldap,
}:

stdenv.mkDerivation rec {
  pname = "apache-httpd";
  version = "2.4.62";

  src = fetchurl {
    url = "mirror://apache/httpd/httpd-${version}.tar.bz2";
    hash = "sha256-Z0GI579EztgtqNtSLalGhJ4iCA1z0WyT9/TfieJXKew=";
  };

  patches = [
    (fetchpatch2 {
      name = "apache-httpd-cross-compile.patch";
      url = "https://gitlab.com/buildroot.org/buildroot/-/raw/5dae8cddeecf16c791f3c138542ec51c4e627d75/package/apache/0001-cross-compile.patch";
      hash = "sha256-KGnAa6euOt6dkZQwURyVITcfqTkDkSR8zpE97DywUUw=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];
  setOutputFlags = false;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    perl
    which
  ];

  buildInputs = [
    perl
    libxcrypt
    zlib
    openssl
    libxml2
    openldap
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postPatch = ''
    sed -i config.layout -e "s|installbuilddir:.*|installbuilddir: $dev/share/build|"
    sed -i configure -e 's|perlbin=.*|perlbin="/usr/bin/env perl"|'
    sed -i support/apachectl.in -e 's|@LYNX_PATH@|lynx|'
  '';

  NIX_LDFLAGS = lib.optionalString (!stdenv.hostPlatform.isDarwin) "-lgcc_s";

  configureFlags = [
    "--with-apr=${apr.dev}"
    "--with-apr-util=${aprutil.dev}"
    "--with-z=${zlib.dev}"
    "--with-pcre=${pcre2.dev}/bin/pcre2-config"
    "--disable-maintainer-mode"
    "--disable-debugger-mode"
    "--enable-mods-shared=all"
    "--enable-mpms-shared=all"
    "--enable-cern-meta"
    "--enable-imagemap"
    "--enable-cgi"
    "--includedir=${placeholder "dev"}/include"
    "--enable-proxy"
    "--enable-ssl"
    "--with-libxml2=${libxml2.dev}/include/libxml2"
    "--docdir=$(doc)/share/doc"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "ap_cv_void_ptr_lt_long=no"
  ];

  enableParallelBuilding = true;

  stripDebugList = [
    "lib"
    "modules"
    "bin"
  ];

  postInstall = ''
    mkdir -p $doc/share/doc/httpd
    mv $out/manual $doc/share/doc/httpd
    mkdir -p $dev/bin
    mv $out/bin/apxs $dev/bin/apxs
  '';

  passthru = {
    inherit apr aprutil;
  };

  meta = {
    description = "Apache HTTPD, the world's most popular web server";
    homepage = "https://httpd.apache.org/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
