{
  lib,
  php,
  libssh2,
}:

php.buildPecl rec {
  pname = "ssh2";
  version = "1.4.1";
  sha256 = "sha256-e8pbI/cx252O0K6l25uxXaj/EzsPu6lhArguldpNh2Q=";

  buildInputs = [ libssh2 ];
  configureFlags = [ "--with-ssh2=${libssh2.dev}" ];

  meta = {
    description = "PHP bindings for the libssh2 library";
    homepage = "https://github.com/php/pecl-networking-ssh2";
    license = lib.licenses.php301;
  };
}
