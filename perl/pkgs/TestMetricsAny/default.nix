{
  buildPerlModule,
  fetchurl,
  lib,
  MetricsAny,
}:
buildPerlModule {
  pname = "Test-Metrics-Any";
  version = "0.01";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PEVANS/Test-Metrics-Any-0.01.tar.gz";
    hash = "sha256-JQbIjU6yGydLEIX4BskY3Ml//2nhbRJJ5uGdlDYl5Gg=";
  };
  propagatedBuildInputs = [ MetricsAny ];
  meta = {
    description = "Assert that code produces metrics via Metrics::Any";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
