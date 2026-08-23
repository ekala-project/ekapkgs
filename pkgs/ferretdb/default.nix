{
  lib,
  buildGo126Module,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "ferretdb";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "FerretDB";
    repo = "FerretDB";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WMejspnk2PvJhvNGi4h+DF+fzipuOMcS1QWim5DnAhQ=";
  };

  postPatch = ''
    echo v${finalAttrs.version} > build/version/version.txt
    echo nixpkgs     > build/version/package.txt
  '';

  vendorHash = "sha256-GT6e9yd6LF6GFlGBWVAmcM6ysB/6cIGLbnM0hxfX5TE=";

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
