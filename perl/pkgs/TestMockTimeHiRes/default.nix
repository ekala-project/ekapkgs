{
  buildPerlModule,
  fetchurl,
  lib,
  AnyEvent,
  ModuleBuildTiny,
  TestClass,
  TestRequires,
  TestMockTime,
}:
buildPerlModule {
  pname = "Test-MockTime-HiRes";
  version = "0.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TA/TARAO/Test-MockTime-HiRes-0.08.tar.gz";
    hash = "sha256-X0n3rviV0yfa/fJ0TznBdsirDkuCJ9LW495omiWb3sE=";
  };
  buildInputs = [
    AnyEvent
    ModuleBuildTiny
    TestClass
    TestRequires
  ];
  propagatedBuildInputs = [ TestMockTime ];
  meta = {
    description = "Replaces actual time with simulated high resolution time";
    homepage = "https://github.com/tarao/perl5-Test-MockTime-HiRes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
