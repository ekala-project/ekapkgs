{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "open-code-review";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "alibaba";
    repo = "open-code-review";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dDKNxjI0pWoJGabUvsGTERYKvKtvEm3UGD/FLPKpfnw=";
  };

  vendorHash = "sha256-LpqnNp6gxHatHH68pM59ESQICDDSVrkZm7AJLVvYTao=";

  subPackages = [ "cmd/opencodereview" ];

  # Upstream's suite shells out to git (git_test.go) — make test assumes it.
  # gitMinimal (as in gitleaks): the full git build needs asciidoc for docs.
  nativeCheckInputs = [ gitMinimal ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  # The CLI presents itself as `ocr` (cobra root Use, npm bin, docs) but the
  # Go main package builds as `opencodereview` — link the expected name.
  postInstall = ''
    ln -s $out/bin/opencodereview $out/bin/ocr
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = {
    description = "AI-powered code review CLI — reviews git diffs via configurable LLMs";
    homepage = "https://github.com/alibaba/open-code-review";
    changelog = "https://github.com/alibaba/open-code-review/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "ocr";
    platforms = lib.platforms.linux;
  };
})
