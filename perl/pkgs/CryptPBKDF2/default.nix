{
  buildPerlModule,
  fetchurl,
  lib,
  ModuleBuildTiny,
  TestFatal,
  CryptURandom,
  DigestHMAC,
  DigestSHA3,
  Moo,
  TypeTiny,
  namespaceautoclean,
  strictures,
}:
buildPerlModule {
  pname = "Crypt-PBKDF2";
  version = "0.261630";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARODLAND/Crypt-PBKDF2-0.261630.tar.gz";
    hash = "sha256-GHVxiWOJMrMJs0xFu4EKo+SFbj7VgBAAF9reZXk/RsA=";
  };
  buildInputs = [
    ModuleBuildTiny
    TestFatal
  ];
  propagatedBuildInputs = [
    CryptURandom
    DigestHMAC
    DigestSHA3
    Moo
    TypeTiny
    namespaceautoclean
    strictures
  ];
  meta = {
    description = "PBKDF2 password hash algorithm";
    homepage = "https://metacpan.org/release/Crypt-PBKDF2";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
