{
  lib,
  stdenv,
  fetchFromGitHub,
  php,
  autoconf,
  pkg-config,
  re2c,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "php-memcache";
  version = "8.2";

  src = fetchFromGitHub {
    owner = "websupport-sk";
    repo = "pecl-memcache";
    rev = version;
    hash = "sha256-77GvQ59XUpIZmdYZP6IhtjdkYwXKuNBSG+LBScz2BtI=";
  };

  nativeBuildInputs = [
    php
    autoconf
    pkg-config
    re2c
  ];

  buildInputs = [
    php
    zlib
  ];

  configurePhase = ''
    runHook preConfigure
    phpize
    ./configure --with-php-config=${php}/bin/php-config --with-zlib-dir=${zlib.dev}
    runHook postConfigure
  '';

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];

  meta = {
    description = "PHP extension for interfacing with memcached";
    homepage = "https://github.com/websupport-sk/pecl-memcache";
    license = lib.licenses.php301;
    broken = true; # missing php_smart_string_public.h header
  };
}
