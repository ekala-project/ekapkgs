{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Text-Format";
  version = "0.62";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Text-Format-0.62.tar.gz";
    hash = "sha256-fUKQVzGeEjxZC6B2UzTwreSl656o23wOxNOQLeX5BAQ=";
  };

  meta = {
    description = "Various subroutines to format text";
  };
}
