{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Crypt-OpenSSL-Guess";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AK/AKIYM/Crypt-OpenSSL-Guess-0.15.tar.gz";
    hash = "sha256-HFAzOBgZ/bTJCH3SkbkOxw54ENMdV+remziOzP1wOG0=";
  };
  meta = {
    description = "Guess OpenSSL include path";
  };
}
