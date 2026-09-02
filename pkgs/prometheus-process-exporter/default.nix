{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "process-exporter";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "ncabatoff";
    repo = "process-exporter";
    rev = "v${version}";
    sha256 = "sha256-dxXBhrZdYM+mH73K/cdaSmfzbzZaPJYCTzcfXGYMlyY=";
  };

  vendorHash = "sha256-3uhwP8WgZ+zmP6Ex1xcQIj/qGoAot/YC3Vu+leMqEQ4=";

  postPatch = ''
    substituteInPlace proc/read_test.go --replace /bin/cat cat
  '';

  doCheck = true;
  meta = {
    description = "Prometheus exporter that mines /proc to report on selected processes";
    homepage = "https://github.com/ncabatoff/process-exporter";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
