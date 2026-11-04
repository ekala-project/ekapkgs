{
  buildPerlPackage,
  fetchurl,
  lib,
  TestRequires,
}:
buildPerlPackage {
  pname = "Test-SharedFork";
  version = "0.35";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/EX/EXODIST/Test-SharedFork-0.35.tar.gz";
    hash = "sha256-KTLoZWEOgHWPdkxYZ1fvjhHbEoTZWOJeS3qFCYQUxZ8=";
  };

  buildInputs = [ TestRequires ];

  meta = {
    description = "Fork test";
    homepage = "https://github.com/tokuhirom/Test-SharedFork";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
