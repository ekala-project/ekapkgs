{
  buildPerlPackage,
  fetchurl,
  lib,
  TestFatal,
  TestWarnings,
  DateTime,
}:
buildPerlPackage {
  pname = "DateTime-Format-Strptime";
  version = "1.79";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Strptime-1.79.tar.gz";
    hash = "sha256-cB5GgCyG7U2IaVwabay76QszkL7reU84fnx5IwADdXk=";
  };
  buildInputs = [
    TestFatal
    TestWarnings
  ];
  propagatedBuildInputs = [ DateTime ];
  meta = {
    description = "Parse and format strp and strf time patterns";
    license = lib.licenses.artistic2;
  };
}
