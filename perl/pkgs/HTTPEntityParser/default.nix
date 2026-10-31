{
  buildPerlModule,
  fetchurl,
  lib,
  HTTPMessage,
  ModuleBuildTiny,
  HTTPMultiPartParser,
  HashMultiValue,
  JSONMaybeXS,
  StreamBuffered,
  WWWFormUrlEncoded,
}:
buildPerlModule {
  pname = "HTTP-Entity-Parser";
  version = "0.25";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/HTTP-Entity-Parser-0.25.tar.gz";
    hash = "sha256-OozQ2Muj0XzYwE7oLXNB36okfb3ZSknrlLU/aeSD7Do=";
  };
  propagatedBuildInputs = [
    HTTPMultiPartParser
    HashMultiValue
    JSONMaybeXS
    StreamBuffered
    WWWFormUrlEncoded
  ];
  buildInputs = [
    HTTPMessage
    ModuleBuildTiny
  ];
  meta = {
    description = "PSGI compliant HTTP Entity Parser";
    homepage = "https://github.com/kazeburo/HTTP-Entity-Parser";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
