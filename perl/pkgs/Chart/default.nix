{
  buildPerlPackage,
  fetchurl,
  TestWarn,
  GD,
  GraphicsToolkitColor,
}:
buildPerlPackage {
  pname = "Chart";
  version = "2.403.9";
  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LI/LICHTKIND/Chart-v2.403.9.tar.gz";
    hash = "sha256-V8aCi7TIpyFw/rZ9wfFIq/Gcqzgnd54wh3tGEe1n86s=";
  };
  buildInputs = [ TestWarn ];
  propagatedBuildInputs = [
    GD
    GraphicsToolkitColor
  ];
  meta = {
    description = "Series of charting modules";
  };
}
