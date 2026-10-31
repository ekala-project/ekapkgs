{
  lib,
  php,
  fetchFromGitHub,
  pkg-config,
  cyrus_sasl,
  icu,
  openssl,
  snappy,
  zlib,
  pcre2,
}:

php.buildPecl rec {
  pname = "mongodb";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-php-driver";
    rev = version;
    hash = "sha256-zhF1YF/jZpXS0PfVwZ2uDluHY8HTqWhXVa0J1TGo5aA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    cyrus_sasl
    icu
    openssl
    snappy
    zlib
    pcre2
  ];

  meta = {
    description = "Official MongoDB PHP driver";
    homepage = "https://github.com/mongodb/mongo-php-driver";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
