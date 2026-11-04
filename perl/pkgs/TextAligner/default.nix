{
  buildPerlModule,
  fetchurl,
  lib,
}:
buildPerlModule {
  pname = "Text-Aligner";
  version = "0.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Aligner-0.16.tar.gz";
    hash = "sha256-XIV9vOWG9X+j18Tr0yACOrOyljsgSUKK4BvTvE8hVyU=";
  };

  meta = {
    description = "Module to align text";
    homepage = "https://metacpan.org/release/Text-Aligner";
    license = lib.licenses.isc;
  };
}
