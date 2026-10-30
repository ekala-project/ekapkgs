{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gyp";
  version = "0.0.0-unstable-2024-09-09";

  src = fetchFromGitHub {
    owner = "nodejs";
    repo = "gyp-next";
    tag = "v0.19.1";
    hash = "sha256-pfRnYsr9zFfHJFO8bj5d5VPhBfWTB4+wCP/dnvNcrrw=";
  };

  pyproject = true;

  build-system = [ python3.pkgs.setuptools ];

  dependencies = [ python3.pkgs.setuptools ];

  meta = {
    description = "Generate Your Projects - a build system generator";
    homepage = "https://github.com/nodejs/gyp-next";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    mainProgram = "gyp";
  };
})
