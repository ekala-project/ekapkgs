{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Net-OpenSSH";
  version = "0.84";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SA/SALVA/Net-OpenSSH-0.84.tar.gz";
    hash = "sha256-h4DmLwGxzw20PJy3BclP9JSbAyIzvkvpH8kavHkVOfg=";
  };
  meta = {
    description = "Perl SSH client package implemented on top of OpenSSH";
  };
}
