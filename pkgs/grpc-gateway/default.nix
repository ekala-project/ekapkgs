{
  buildGo126Module,
  fetchFromGitHub,
  lib,
}:

buildGo126Module (finalAttrs: {
  pname = "grpc-gateway";
  version = "2.29.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-d9OIIGttyMBSNgpS6mbR5JEIm13qGu2gFHJazJAexdw=";
  };

  vendorHash = "sha256-p51yD+v8+rPs+ztlX7r0VQ4XlwUkxu+PxgknKEvH00k=";

  ldflags = [
    "-X=main.version=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=${finalAttrs.version}"
  ];

  meta = {
    description = "GRPC to JSON proxy generator plugin for Google Protocol Buffers";
    homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
