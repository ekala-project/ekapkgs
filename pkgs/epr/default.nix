{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "epr";
  version = "2.4.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wustho";
    repo = "epr";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-HIgJdoiynqvb1hgKPC6rbBAqi6SgwF7vC4oM+Mra4xk=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  meta = {
    description = "CLI Epub Reader";
    mainProgram = "epr";
    homepage = "https://github.com/wustho/epr";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
