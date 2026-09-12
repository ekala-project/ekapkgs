{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "uglify-js";
  version = "3.19.3";

  src = fetchFromGitHub {
    owner = "mishoo";
    repo = "UglifyJS";
    rev = "v${version}";
    hash = "sha256-sMLQSB1+ux/ya/J22KGojlAxWhtPQdk22KdHy43zdyg=";
  };

  npmDepsHash = "sha256-/Xb8DT7vSzZPEd+Z+z1BlFnrOeOwGP+nGv2K9iz6lKI=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    homepage = "https://github.com/mishoo/UglifyJS";
    changelog = "https://github.com/mishoo/UglifyJS/releases/tag/v" + version;
    description = "JavaScript parser / mangler / compressor / beautifier toolkit";
    mainProgram = "uglifyjs";
    license = lib.licenses.bsd2;
  };
}
