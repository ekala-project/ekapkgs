{
  buildPerlModule,
  fetchurl,
  DateTime,
  TimeDate,
}:
buildPerlModule {
  pname = "DateTime-Format-DateParse";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JH/JHOBLITT/DateTime-Format-DateParse-0.05.tar.gz";
    hash = "sha256-9uykyL5mzpmS7hUJMvj88HgJ/T0WZMryALil/Tp+Xrw=";
  };
  propagatedBuildInputs = [
    DateTime
    TimeDate
  ];
  meta = {
    description = "Parses Date::Parse compatible formats";
  };
}
