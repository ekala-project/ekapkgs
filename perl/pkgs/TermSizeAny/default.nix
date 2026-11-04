{
  buildPerlPackage,
  fetchurl,
  DevelHide,
  TermSizePerl,
}:
buildPerlPackage {
  pname = "Term-Size-Any";
  version = "0.002";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FE/FERREIRA/Term-Size-Any-0.002.tar.gz";
    hash = "sha256-ZPpf2xrjqCMTSqqVrsdTVLwXvdnKEroKeuNKflGz3tI=";
  };

  propagatedBuildInputs = [
    DevelHide
    TermSizePerl
  ];

  meta = {
    description = "Retrieve terminal size";
  };
}
