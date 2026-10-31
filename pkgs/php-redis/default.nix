{
  lib,
  php,
  stdenv,
  fetchFromGitHub,
  pcre2,
  pkg-config,
  autoconf,
}:

stdenv.mkDerivation rec {
  pname = "php-redis";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "phpredis";
    repo = "phpredis";
    rev = version;
    hash = "sha256-mdphyUG4OUc1PBEA5Ub1X9afFDMJ5+HoXH4WnmeAKpE=";
  };

  nativeBuildInputs = [
    php
    autoconf
    pkg-config
  ];

  buildInputs = [
    php
    pcre2
  ];

  configurePhase = ''
    runHook preConfigure
    phpize
    ./configure --with-php-config=${php}/bin/php-config
    runHook postConfigure
  '';

  makeFlags = [ "phpincludedir=$(dev)/include" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/php/extensions
    cp modules/*.so $out/lib/php/extensions/
    runHook postInstall
  '';

  meta = {
    description = "PHP extension for interfacing with Redis";
    homepage = "https://github.com/phpredis/phpredis/";
    license = lib.licenses.php301;
  };
}
