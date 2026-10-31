{
  lib,
  php,
  fetchurl,
  libssh2,
}:

php.buildPecl {
  pname = "ssh2";
  version = "1.4.1";

  src = fetchurl {
    url = "https://pecl.php.net/get/ssh2-1.4.1.tgz";
    hash = "sha256-e8pbI/cx252O0K6l25uxXaj/EzsPu6lhArguldpNh2Q=";
  };

  buildInputs = [ libssh2 ];
  configureFlags = [ "--with-ssh2=${libssh2.dev}" ];

  meta = {
    description = "PHP bindings for the libssh2 library";
    homepage = "https://github.com/php/pecl-networking-ssh2";
    license = lib.licenses.php301;
  };
}
