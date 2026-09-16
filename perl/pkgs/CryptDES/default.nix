{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Crypt-DES";
  version = "2.07";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DP/DPARIS/Crypt-DES-2.07.tar.gz";
    hash = "sha256-LbHrtYN7TLIAUcDuW3M7RFPjE33wqSMGA0yGdiHt1+c=";
  };
  patches = [
    ./CryptDES-expose-perl_des_expand_key-and-perl_des_crypt.patch
  ];
  meta = {
    description = "Perl DES encryption module";
  };
}
