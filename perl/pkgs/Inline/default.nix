{
  buildPerlPackage,
  fetchurl,
  TestWarn,
}:
buildPerlPackage {
  pname = "Inline";
  version = "0.86";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IN/INGY/Inline-0.86.tar.gz";
    hash = "sha256-UQp94tARsNuAsIdOjA9zkAEJkQAK4TXP90dN8ebVHjo=";
  };
  buildInputs = [ TestWarn ];
  meta = {
    description = "Write Perl Subroutines in Other Programming Languages";
  };
}
