{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "blocky";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "0xERR0R";
    repo = "blocky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RLK5Bleu3TGEL1ti7R5kRVtUOCZfj9jOHnAbDRQ1Rsw=";
  };

  # needs network connection and fails at
  # https://github.com/0xERR0R/blocky/blob/development/resolver/upstream_resolver_test.go

  vendorHash = "sha256-LSlyRhhW6q4d7bahDJ5qF4H2ajzp+vWOAwxG+2JFqVY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/0xERR0R/blocky/util.Version=${finalAttrs.version}"
  ];

  passthru.tests = { };

  meta = {
    description = "Fast and lightweight DNS proxy as ad-blocker for local network with many features";
    homepage = "https://0xerr0r.github.io/blocky";
    changelog = "https://github.com/0xERR0R/blocky/releases";
    license = lib.licenses.asl20;
    mainProgram = "blocky";
  };
})
