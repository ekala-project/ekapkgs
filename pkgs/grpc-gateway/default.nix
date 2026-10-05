{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "grpc-gateway";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-sQjeryLDvp2rw41eX4JhBquEemCBdumnpb7+c7iEiag=";
  };

  vendorHash = "sha256-CpQiMBXazT5t2+apej1MqIVuJKdr+BJJcz17Utoth4Y=";

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
