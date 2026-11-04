{
  buildPerlPackage,
  fetchurl,
  lib,
  IOSocketSSL,
  perl,
}:
buildPerlPackage {

  pname = "App-cpanminus";
  version = "1.7047";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/App-cpanminus-1.7047.tar.gz";
    hash = "sha256-lj5jxuGocl/y9iTpCGOWrhUNtR3QozfDeB0JqZSvBaU=";
  };
  # CVE-2024-45321: Use TLS endpoints for downloads and metadata
  preConfigure = ''
    substituteInPlace bin/cpanm \
      --replace-fail http://www.cpan.org https://www.cpan.org \
      --replace-fail http://cpan.metacpan.org https://cpan.metacpan.org \
      --replace-fail http://backpan.perl.org https://backpan.perl.org \
      --replace-fail http://fastapi.metacpan.org https://fastapi.metacpan.org \
      --replace-fail http://cpanmetadb.plackperl.org https://cpanmetadb.plackperl.org
  '';
  propagatedBuildInputs = [ IOSocketSSL ];
  meta = {
    description = "Get, unpack, build and install modules from CPAN";
    homepage = "https://github.com/miyagawa/cpanminus";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "cpanm";
  };

}
