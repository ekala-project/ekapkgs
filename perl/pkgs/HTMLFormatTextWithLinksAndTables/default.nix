{
  buildPerlPackage,
  fetchurl,
  HTMLFormatTextWithLinks,
}:
buildPerlPackage {
  pname = "HTML-FormatText-WithLinks-AndTables";
  version = "0.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DALEEVANS/HTML-FormatText-WithLinks-AndTables-0.07.tar.gz";
    hash = "sha256-gJ7i8RcFcGszxUMStce+5nSDjyvqrtr4y5RecCquObY=";
  };

  propagatedBuildInputs = [ HTMLFormatTextWithLinks ];

  meta = {
    description = "Converts HTML to Text with tables intact";
  };
}
