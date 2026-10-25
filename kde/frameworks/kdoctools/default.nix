{
  mkKdeDerivation,
  docbook-xml-dtd,
  docbook-xsl-nons,
  perl,
  perlPackages,
  libxml2,
}:
mkKdeDerivation {
  pname = "kdoctools";

  # Perl could be used both at build time and at runtime.
  extraNativeBuildInputs = [
    perl
    perlPackages.URI
    libxml2
  ];
  extraBuildInputs = [
    docbook-xml-dtd.v4_5
    docbook-xsl-nons
  ];
  extraPropagatedBuildInputs = [
    perl
    perlPackages.URI
  ];
}
