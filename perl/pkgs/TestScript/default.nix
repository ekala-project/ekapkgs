{
  buildPerlPackage,
  fetchurl,
  lib,
  Test2Suite,
  CaptureTiny,
  ProbePerl,
}:
buildPerlPackage {
  pname = "Test-Script";
  version = "1.29";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PL/PLICEASE/Test-Script-1.29.tar.gz";
    hash = "sha256-iS5+bB6nsWcQkJlCz1wL2rcO7i79SqnBbqlS4rkPiVA=";
  };

  buildInputs = [ Test2Suite ];

  propagatedBuildInputs = [
    CaptureTiny
    ProbePerl
  ];

  preCheck = ''
    # Remove tests with hardcoded line numbers.
    rm t/test_script__script_compiles.t
  '';

  meta = {
    description = "Basic cross-platform tests for scripts";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
