{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  fetchpatch,
}:

buildGo126Module (finalAttrs: {
  pname = "ginkgo";
  version = "2.28.1";

  src = fetchFromGitHub {
    owner = "onsi";
    repo = "ginkgo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mevZN35RUpaPmAYw3lfmzvdT2H+yucD8g3/bX9Rl00s=";
  };
  vendorHash = "sha256-I3n1FPINb/nhi4QUzRFEspn7REN1dQEPg8Bhb3PemQU=";

  patches = [
    (fetchpatch {
      url = "https://github.com/onsi/ginkgo/pull/1648.patch";
      hash = "sha256-O8YWPAvf0ukPWSTm6+YKnV/L+qSL0RCoBswmiQVXOKI=";
    })
  ];

  excludedPackages = [
    "integration"
    "types"
  ];

  doCheck = false;

  meta = {
    homepage = "https://onsi.github.io/ginkgo/";
    changelog = "https://github.com/onsi/ginkgo/blob/master/CHANGELOG.md";
    description = "Modern Testing Framework for Go";
    mainProgram = "ginkgo";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
