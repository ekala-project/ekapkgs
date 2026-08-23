{
  buildGo126Module,
  lib,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "frp";
  version = "0.70.1";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QV+Ti54JIWzBDm6urUSnkMQAxV8eewsIEbVm/hvcx3k=";
  };

  vendorHash = "sha256-TCXiZP8MpkIRqSAoDviHsIBFQuOdhCWzSvXt84rs+bE=";

  doCheck = false;

  preBuild = ''
    mkdir -p web/frpc/dist web/frps/dist
    echo '<!DOCTYPE html><html></html>' > web/frpc/dist/index.html
    echo '<!DOCTYPE html><html></html>' > web/frps/dist/index.html
  '';

  subPackages = [
    "cmd/frpc"
    "cmd/frps"
  ];

  meta = {
    description = "Fast reverse proxy";
    homepage = "https://github.com/fatedier/frp";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
