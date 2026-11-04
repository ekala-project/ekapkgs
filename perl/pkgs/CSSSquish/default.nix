{
  buildPerlPackage,
  fetchurl,
  TestLongString,
  URI,
}:
buildPerlPackage {
  pname = "CSS-Squish";
  version = "0.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TS/TSIBLEY/CSS-Squish-0.10.tar.gz";
    hash = "sha256-ZfwNaazR+jPZpMOwnM4PvXN9dHsfzE6dh+vZEFDLy04=";
  };
  buildInputs = [ TestLongString ];
  propagatedBuildInputs = [ URI ];
  meta = {
    description = "Compact many CSS files into one big file";
  };
}
