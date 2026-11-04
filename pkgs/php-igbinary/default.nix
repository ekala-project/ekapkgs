{
  lib,
  php,
  fetchurl,
}:

php.buildPecl {
  pname = "igbinary";
  version = "3.2.14";

  src = fetchurl {
    url = "https://pecl.php.net/get/igbinary-3.2.14.tgz";
    hash = "sha256-YzcUek+4iAclZmdIN72pko7gbufwEUtDOLhsgWIykl0=";
  };

  configureFlags = [ "--enable-igbinary" ];

  meta = {
    broken = true; # eval error, missing src argument
    description = "Binary serialization for PHP";
    homepage = "https://github.com/igbinary/igbinary/";
    license = lib.licenses.bsd3;
  };
}
