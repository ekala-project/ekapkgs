{
  buildPerlPackage,
  fetchurl,
  pkg-config,
  zlib,
  libxml2,
  libxslt,
  XMLLibXML,
}:
buildPerlPackage {
  pname = "XML-LibXSLT";
  version = "2.002001";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/XML-LibXSLT-2.002001.tar.gz";
    hash = "sha256-34knxP8ZSfYlgNHB5vAPDNVrU9OpV+5LFxtZv/pjssA=";
  };
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    libxml2
    libxslt
  ];
  propagatedBuildInputs = [ XMLLibXML ];
}
