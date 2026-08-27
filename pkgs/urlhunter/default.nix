{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "urlhunter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "utkusen";
    repo = "urlhunter";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QRQLN8NFIIvlK+sHNj0MMs7tlBODMKHdWJFh/LwnysI=";
  };

  vendorHash = "sha256-tlFCovCzqgaLcxcGmWXLYUjaAvFG0o11ei8uMzWJs6Q=";

  meta = {
    description = "Recon tool that allows searching shortened URLs";
    mainProgram = "urlhunter";
    homepage = "https://github.com/utkusen/urlhunter";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
