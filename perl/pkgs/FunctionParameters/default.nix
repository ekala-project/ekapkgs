{
  buildPerlPackage,
  fetchurl,
  DirSelf,
  TestFatal,
}:
buildPerlPackage {
  pname = "Function-Parameters";
  version = "2.002004";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MAUKE/Function-Parameters-2.002004.tar.gz";
    hash = "sha256-KKvqWODAnOMnmaCMvXr3DaHimXd8KZEZQpygaacYg+g=";
  };

  buildInputs = [
    DirSelf
    TestFatal
  ];

  meta = {
    description = "Define functions and methods with parameter lists (subroutine signatures)";
  };
}
