{
  buildPerlPackage,
  fetchurl,
  lib,
  LWP,
  SafeIsa,
  namespaceclean,
  PathTiny,
  Plack,
  TestDeep,
  TestFatal,
  TestNeeds,
  TestRequiresInternet,
  TestWarnings,
}:
buildPerlPackage {
  pname = "Test-LWP-UserAgent";
  version = "0.036";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Test-LWP-UserAgent-0.036.tar.gz";
    hash = "sha256-BTJ1MNNGuAphpulD+9dJmGvcqJIRpOswHAjC0XkxThE=";
  };
  propagatedBuildInputs = [
    LWP
    SafeIsa
    namespaceclean
  ];
  buildInputs = [
    PathTiny
    Plack
    TestDeep
    TestFatal
    TestNeeds
    TestRequiresInternet
    TestWarnings
  ];
  meta = {
    description = "LWP::UserAgent suitable for simulating and testing network calls";
    homepage = "https://github.com/karenetheridge/Test-LWP-UserAgent";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
