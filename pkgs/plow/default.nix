{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "plow";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "six-ddc";
    repo = "plow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0/nMF9fqRMzN4bfK6EsTi5MW+OUG/dv4UKr5j/AhRoM=";
  };

  vendorHash = "sha256-nGAPuyS95bHPkQMdHdtbdVWQ+MBOOHnHPh7bkSHji4E=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "High-performance HTTP benchmarking tool that includes a real-time web UI and terminal display";
    homepage = "https://github.com/six-ddc/plow";
    changelog = "https://github.com/six-ddc/plow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "plow";
  };
})
