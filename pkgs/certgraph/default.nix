{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "certgraph";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = "certgraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-76OqwLGg+ZMLvY281XvRTSpOq6iLPAnLRjDs/Xee2hQ=";
  };

  vendorHash = "sha256-AvwoQffkiaK3QsV5UXO0EwFM/Y3DxVMp0brKiFD+N7I=";

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    changelog = "https://github.com/lanrat/certgraph/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    mainProgram = "certgraph";
  };
})
