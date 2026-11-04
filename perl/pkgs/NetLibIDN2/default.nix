{
  buildPerlModule,
  fetchurl,
  lib,
  libidn,
}:
buildPerlModule {
  pname = "Net-LibIDN2";
  version = "1.02";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TH/THOR/Net-LibIDN2-1.02.tar.gz";
    hash = "sha256-0fMK/GrPplQbAMCafkx059jkuknjJ3wLvEGuNcE5DQc=";
  };

  propagatedBuildInputs = [ libidn.v2 ];

  meta = {
    description = "Perl bindings for GNU Libidn2";
    homepage = "https://github.com/gnuthor/Net--LibIDN2";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
