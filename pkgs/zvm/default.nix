{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "zvm";
  version = "0.8.22";

  src = fetchFromGitHub {
    owner = "tristanisham";
    repo = "zvm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uKn4ysaNuvWpV4fhrpm7pdS61pQJTYr6WfIhBzTfNT8=";
  };

  vendorHash = "sha256-kJrCUxzbpyxEUF9UQeAI28tWKA+T7zT1DBI1wf3pjjM=";

  meta = {
    homepage = "https://www.zvm.app/";
    downloadPage = "https://github.com/tristanisham/zvm";
    changelog = "https://github.com/tristanisham/zvm/releases/tag/v${finalAttrs.version}";
    description = "Tool to manage and use different Zig versions";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "zvm";
  };
})
