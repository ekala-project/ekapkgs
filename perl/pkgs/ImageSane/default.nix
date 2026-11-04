{
  buildPerlPackage,
  fetchurl,
  lib,
  sane-backends,
  ExtUtilsDepends,
  ExtUtilsPkgConfig,
  TestRequires,
  TryTiny,
  ExceptionClass,
  Readonly,
}:
buildPerlPackage {
  pname = "Image-Sane";
  version = "5";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RA/RATCLIFFE/Image-Sane-5.tar.gz";
    hash = "sha256-Ipqg6fBJ76dg88L25h2dU5r0PY92S1Cm4DBktHKaNf8=";
  };
  buildInputs = [
    sane-backends
    ExtUtilsDepends
    ExtUtilsPkgConfig
    TestRequires
    TryTiny
  ];
  propagatedBuildInputs = [
    ExceptionClass
    Readonly
  ];
  meta = {
    description = "Perl extension for the SANE (Scanner Access Now Easy) Project";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
