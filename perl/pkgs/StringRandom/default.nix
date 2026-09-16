{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "String-Random";
  version = "0.32";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/String-Random-0.32.tar.gz";
    hash = "sha256-nZPGeaNP+ibTtPoIN8rtHNLmfXZXKBi5HpfepzRwUkY=";
  };
  meta = {
    description = "Perl module to generate random strings based on a pattern";
  };
}
