{
  lib,
  php,
  stdenv,
  fetchFromGitHub,
  pcre2,
  pkg-config,
  autoconf,
}:

# Use stdenv.mkDerivation directly instead of php.buildPecl to avoid
# autoreconfHook libtool version mismatch with phpize-generated scripts.
stdenv.mkDerivation {
  pname = "php-apcu";
  version = "5.1.28";

  src = fetchFromGitHub {
    owner = "krakjoe";
    repo = "apcu";
    rev = "v5.1.28";
    sha256 = "sha256-L8bGSPUuBsZXsJdeY6cVA0DvI2+0wEbNHH6IcfT+cFU=";
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
    description = "Userland cache for PHP";
    homepage = "https://pecl.php.net/package/APCu";
    license = lib.licenses.php301;
  };
}
