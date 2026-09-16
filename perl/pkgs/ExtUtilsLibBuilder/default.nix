{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "ExtUtils-LibBuilder";
  version = "0.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AM/AMBS/ExtUtils-LibBuilder-0.08.tar.gz";
    hash = "sha256-xRFx4G3lMDnwvKHZemRx7DeUH/Weij0csXDr3SVztdI=";
  };
}
