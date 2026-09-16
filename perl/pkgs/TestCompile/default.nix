{
  buildPerlModule,
  fetchurl,
  UNIVERSALrequire,
}:
buildPerlModule {
  pname = "Test-Compile";
  version = "3.3.1";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EG/EGILES/Test-Compile-v3.3.1.tar.gz";
    hash = "sha256-gIRQ89Ref0GapNZo4pgodonp6jY4hpO/8YDXhwzj5iE=";
  };
  propagatedBuildInputs = [ UNIVERSALrequire ];
  meta = {
    description = "Assert that your Perl files compile OK";
  };
}
