{
  buildPerlModule,
  fetchurl,
  TestTrap,
  PathTiny,
}:
buildPerlModule {
  pname = "Test-RunValgrind";
  version = "0.2.2";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHLOMIF/Test-RunValgrind-0.2.2.tar.gz";
    hash = "sha256-aRPRTK3CUbI8W3I1+NSsPeKHE41xK3W9lLACrwuPpe4=";
  };
  buildInputs = [ TestTrap ];
  propagatedBuildInputs = [ PathTiny ];
  meta = {
    description = "Tests that an external program is valgrind-clean";
  };
}
