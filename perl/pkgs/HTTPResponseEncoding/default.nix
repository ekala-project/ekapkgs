{
  buildPerlPackage,
  fetchurl,
  HTTPMessage,
  LWP,
}:
buildPerlPackage {
  pname = "HTTP-Response-Encoding";
  version = "0.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANKOGAI/HTTP-Response-Encoding-0.06.tar.gz";
    hash = "sha256-EBZ7jiOKaCAEqw16zL6dduri21evB8WuLfqAgHSkqKo=";
  };
  propagatedBuildInputs = [ HTTPMessage ];
  buildInputs = [ LWP ];
  meta = {
    description = "Adds encoding() to HTTP::Response";
  };
}
