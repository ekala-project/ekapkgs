{ lib
, buildGo126Module
, fetchFromGitHub
,
}:

buildGo126Module (finalAttrs: {
  pname = "urlfinder";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "urlfinder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtCXCRnI05822+a5Os+I+ZAmL/hC884PRCIPlEY3jok=";
  };

  vendorHash = "sha256-9sIBj1K4N+HTd0OWnhP8+T1pPG9un8+FlpbPFwsV8P8=";

  ldflags = [ "-s" ];

  doCheck = false;

  meta = {
    description = "Tool for passively gathering URLs without active scanning";
    homepage = "https://github.com/projectdiscovery/urlfinder";
    changelog = "https://github.com/projectdiscovery/urlfinder/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "urlfinder";
  };
})
