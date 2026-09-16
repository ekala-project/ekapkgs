{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Date-Simple";
  version = "3.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IZ/IZUT/Date-Simple-3.03.tar.gz";
    hash = "sha256-KaGSYxTOFoGjEtYVXClZDHcd2s+Rt0hYc85EnvIJ3QQ=";
  };
}
