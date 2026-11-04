{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDifferences,
  URI,
}:
buildPerlPackage {
  pname = "Pod-Markdown";
  version = "3.300";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RW/RWSTAUNER/Pod-Markdown-3.300.tar.gz";
    hash = "sha256-7HnpkIo2BXScT+tQVHY+toEt0ztUzoWlEzmqfPmZG3k=";
  };

  buildInputs = [ TestDifferences ];

  propagatedBuildInputs = [ URI ];

  meta = {
    description = "Convert POD to Markdown";
    homepage = "https://github.com/rwstauner/Pod-Markdown";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "pod2markdown";
  };
}
