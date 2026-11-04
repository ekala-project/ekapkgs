{
  buildPerlModule,
  fetchurl,
  HTMLParser,
  SubOverride,
}:
buildPerlModule {
  pname = "HTML-TokeParser-Simple";
  version = "3.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/O/OV/OVID/HTML-TokeParser-Simple-3.16.tar.gz";
    hash = "sha256-7RETXGg55uDq+WlS5qw1Oi8i67QKchZZZx5dLcwOSp0=";
  };
  propagatedBuildInputs = [
    HTMLParser
    SubOverride
  ];
  meta = {
    description = "Easy to use HTML::TokeParser interface";
  };
}
