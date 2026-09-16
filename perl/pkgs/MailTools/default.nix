{
  buildPerlPackage,
  fetchurl,
  TimeDate,
}:
buildPerlPackage {
  pname = "MailTools";
  version = "2.21";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/MailTools-2.21.tar.gz";
    hash = "sha256-Stm9aCa28DonJzMkZrG30piQyNmaMrSzsKjZJu4aRMs=";
  };
  propagatedBuildInputs = [ TimeDate ];
  meta = {
    description = "Various ancient e-mail related modules";
  };
}
