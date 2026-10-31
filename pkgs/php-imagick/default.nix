{
  lib,
  php,
  stdenv,
  fetchurl,
  imagemagick,
  pcre2,
  pkg-config,
  autoconf,
}:

stdenv.mkDerivation rec {
  pname = "php-imagick";
  version = "3.8.1";

  src = fetchurl {
    url = "https://pecl.php.net/get/imagick-${version}.tgz";
    hash = "sha256-OjWHwKUkwX0NrZZzoWC5DNd26DaDhHThc7VJ7YZDUu4=";
  };

  sourceRoot = "imagick-${version}";

  nativeBuildInputs = [
    php
    autoconf
    pkg-config
  ];

  buildInputs = [
    php
    pcre2
    imagemagick
  ];

  configurePhase = ''
    runHook preConfigure
    phpize
    ./configure --with-php-config=${php}/bin/php-config --with-imagick=${imagemagick.dev}
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
    description = "PHP extension to create and modify images using the ImageMagick API";
    homepage = "https://pecl.php.net/package/imagick";
    license = lib.licenses.php301;
  };
}
