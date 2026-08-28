{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:

buildGo126Module (finalAttrs: {
  pname = "grpc-gateway";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-LoSfWF+bJ6p+XVdqauIcgESfse+F57aoADi3mYUf3lo=";
  };

  vendorHash = "sha256-e0CajogxQoHPanjek6nWebV2yHFja0QHHD57SNlLQDI=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=${finalAttrs.version}"
  ];

  meta = {
    description = "GRPC to JSON proxy generator plugin for Google Protocol Buffers";
    homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
    license = lib.licenses.bsd3;
  };
})
