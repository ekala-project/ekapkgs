{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Crypt-PasswdMD5";
  version = "1.42";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Crypt-PasswdMD5-1.42.tgz";
    hash = "sha256-/Tlubn9E7rkj6TyZOUC49nqa7Vb8dKrK8Dj8QFPvO1k=";
  };
  meta = {
    description = "Provide interoperable MD5-based crypt() functions";
  };
}
