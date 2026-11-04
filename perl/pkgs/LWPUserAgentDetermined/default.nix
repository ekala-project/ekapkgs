{
  buildPerlPackage,
  fetchurl,
  LWP,
}:
buildPerlPackage {
  pname = "LWP-UserAgent-Determined";
  version = "1.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AL/ALEXMV/LWP-UserAgent-Determined-1.07.tar.gz";
    hash = "sha256-BtjVDozTaSoRy0+0Si+E5UdqmPDi5qSg386fZ+Vd21M=";
  };

  propagatedBuildInputs = [ LWP ];

  meta = {
    description = "Virtual browser that retries errors";
  };
}
