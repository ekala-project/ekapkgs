{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "open-code-review";
  version = "1.12.11";

  src = fetchFromGitHub {
    owner = "alibaba";
    repo = "open-code-review";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t8pUUVNwMFK0XLg2yrRj5ry1fY2Uti7abFuARdSoIEI=";
  };

  vendorHash = "sha256-f5Ty22wicf1J8+RKnHYcEO7flWn9gkWQODlfunn23EA=";

  subPackages = [ "cmd/opencodereview" ];

  # Upstream's suite shells out to git (git_test.go) — make test assumes it.
  # gitMinimal (as in gitleaks): the full git build needs asciidoc for docs.
  nativeCheckInputs = [ gitMinimal ];

  # buildGoModule already forces CGO_ENABLED=0 (static binary, as upstream's
  # Makefile does) — setting it here collides with the predefined env.

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
    # Peeled commit of tag v1.12.11 (tag object ee83f15 -> commit a758d9c).
    "-X main.GitCommit=a758d9cbfb689937c7857ad64b2dd66adb58c0c2"
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
