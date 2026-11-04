{
  buildPerlPackage,
  fetchurl,
  TaskWeaken,
  ExtUtilsDepends,
}:
buildPerlPackage {
  pname = "B-Utils";
  version = "0.27";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/B-Utils-0.27.tar.gz";
    hash = "sha256-+X9T9qMFAQmqQU/usYTK0QGBLUF2DpUrXYSZP2aF/+o=";
  };

  propagatedBuildInputs = [ TaskWeaken ];

  buildInputs = [ ExtUtilsDepends ];

  meta = {
    description = "Helper functions for op tree manipulation";
  };
}
