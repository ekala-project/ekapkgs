{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "pgweb";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "sosedoff";
    repo = "pgweb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3UWld72AN504+Bo8aIY31qMO1xIRL3MXG5ImzMeSoU8=";
  };

  postPatch = ''
    # Disable tests require network access.
    rm -f pkg/client/{client,dump}_test.go
  '';

  vendorHash = "sha256-7gfziA+rKwS6u63I6DaA2Fi/wvtr1rAJupSNJZB72dU=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        "TestParseOptions"
      ];
    in
    [
      "-skip"
      "${builtins.concatStringsSep "|" skippedTests}"
    ];

  meta = {
    changelog = "https://github.com/sosedoff/pgweb/releases/tag/v${finalAttrs.version}";
    description = "Web-based database browser for PostgreSQL";
    homepage = "https://sosedoff.github.io/pgweb/";
    license = lib.licenses.mit;
    mainProgram = "pgweb";
    maintainers = [ ];
  };
})
