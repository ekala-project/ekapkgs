{ buildPerlModule, fetchurl }:
buildPerlModule {
  pname = "Test-Command";
  version = "0.11";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANBOO/Test-Command-0.11.tar.gz";
    hash = "sha256-KKP8b+pzoZ9WPxG9DygYZ1bUx0IHvm3qyq0m0ggblTM=";
  };
  meta = {
    description = "Test routines for external commands";
  };
}
