{
  buildGo126Module,
  lib,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "frp";
  version = "0.71.0";

  src = fetchFromGitHub {
    owner = "fatedier";
    repo = "frp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q6E77uwV28CUR9LXPDp4DXuBiIvfonybyKIi+aZQvEE=";
  };

  vendorHash = "sha256-TrO0ZVLazqtUpGREb6kjGiTZhGo3R1QK5iHFlojE7po=";

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
  };
})
