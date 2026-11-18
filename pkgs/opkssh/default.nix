{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "opkssh";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "openpubkey";
    repo = "opkssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-omwwWKLu3HwOAvdTmzfQyuHgDiatR9Bvh6u6dP8MmKA=";
  };

  ldflags = [ "-X main.Version=${finalAttrs.version}" ];

  vendorHash = "sha256-EHT04zE9+z2I7CQ3bqIjNfnHOGW9kNJgKT1FkElUxtE=";

  meta = {
    homepage = "https://github.com/openpubkey/opkssh";
    description = "Enables SSH to be used with OpenID Connect";
    license = lib.licenses.asl20;
    mainProgram = "opkssh";
  };
})
