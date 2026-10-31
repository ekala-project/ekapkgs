{
  buildPerlPackage,
  fetchurl,
  PathTiny,
}:
buildPerlPackage {
  pname = "Test-Filename";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DAGOLDEN/Test-Filename-0.03.tar.gz";
    hash = "sha256-akUMxMYoHtESnzKhwHQfIoln/touMqKRX/Yhw2Ul/L4=";
  };
  propagatedBuildInputs = [ PathTiny ];
  meta = {
    description = "Portable filename comparison";
  };
}
