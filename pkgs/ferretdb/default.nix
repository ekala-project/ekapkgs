{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "ferretdb";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x9NpXHXhsDBc94dcNure1BWLofCTDK3WoF5Dxr7H6ck=";
  };

  postPatch = ''
    echo v${finalAttrs.version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-SCbs5ikZbAppChlaTGk98zW9KMQdVtquuCUBveBzV/U=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ferretdb" ];

  doCheck = false;

  meta = {
    description = "Truly Open Source MongoDB alternative";
    mainProgram = "ferretdb";
    homepage = "https://www.ferretdb.com/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
