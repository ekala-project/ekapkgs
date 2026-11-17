{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-gateway";
  version = "2.34.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ell+E75F5KC5OAwuP/tjdeyIouLLAGmcXqeWsJG/HC0=";
  };

  vendorHash = "sha256-0EiubUU7p0HsHWnTLITzpBVB8D1JQSwCe3LmXp52/4A=";

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
