{
  buildPerlPackage,
  fetchurl,
  DateTimeFormatStrptime,
  ParamsValidate,
}:
buildPerlPackage {
  pname = "DateTime-Format-Builder";
  version = "0.83";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Format-Builder-0.83.tar.gz";
    hash = "sha256-Yf+yPYWzyheGstoyiembV+BiX+DknbAqbcDLYsaJ4vI=";
  };
  propagatedBuildInputs = [
    DateTimeFormatStrptime
    ParamsValidate
  ];
}
