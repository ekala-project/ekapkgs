{
  buildPerlPackage,
  fetchurl,
  lib,
  HookLexWrap,
}:
buildPerlPackage {

  pname = "Test-SubCalls";
  version = "1.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-SubCalls-1.10.tar.gz";
    hash = "sha256-y8Hps1oF5x/rwT5e9UejHIJJiZu2AR29ydn/Nm3atsI=";
  };
  propagatedBuildInputs = [ HookLexWrap ];
  meta = {
    description = "Track the number of times subs are called";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };

}
