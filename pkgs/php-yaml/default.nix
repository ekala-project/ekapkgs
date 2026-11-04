{
  lib,
  stdenv,
  fetchurl,
  php,
  autoconf,
  libyaml,
  pkg-config,
  re2c,
}:

stdenv.mkDerivation rec {
  pname = "php-yaml";
  version = "2.2.5";

  src = fetchurl {
    url = "https://pecl.php.net/get/yaml-${version}.tgz";
    hash = "sha256-DHUbSJdJ+/AgcdWwxr/rJsS4Y8Zo74lxHs+VBzkb33E=";
  };

  nativeBuildInputs = [
    php
    autoconf
    pkg-config
    re2c
  ];

  buildInputs = [
    php
    libyaml
  ];

  configurePhase = ''
    runHook preConfigure
    phpize
    ./configure --with-php-config=${php}/bin/php-config --with-yaml=${libyaml.dev}
    runHook postConfigure
  '';

  makeFlags = [ "EXTENSION_DIR=$(out)/lib/php/extensions" ];

  meta = {
    description = "YAML-1.1 parser and emitter";
    homepage = "https://github.com/php/pecl-file_formats-yaml";
    license = lib.licenses.mit;
  };
}
