{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "open-code-review";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "alibaba";
    repo = "open-code-review";
    tag = "v${finalAttrs.version}";
    hash = "sha256-787Pf0RdiOsoaqr3vRsr80MQhyvgWDS0HSeMvwlK78o=";
  };

  vendorHash = "sha256-7/cO+9a/jdN4WuYPdwOUKgT3NFDOSM9Byt4AyjSrJfE=";

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
