{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  setuptools,
  libglvnd,
  libGLU,
  libglut,
  gle,
}:

buildPythonPackage rec {
  pname = "pyopengl";
  version = "3.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mcfletch";
    repo = "pyopengl";
    tag = version;
    hash = "sha256-U/7J3EoxKHp/dR2LAzTiwR5wcjZbUBuT5Dt3c76xxj4=";
  };

  patches = [
    (replaceVars ./ld-preload-gl.patch {
      GL_LD_LIBRARY_PATH = lib.makeLibraryPath [
        "/run/opengl-driver/lib"
        libglvnd
        libGLU
        libglut
        gle
      ];
    })
  ];

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [
    "OpenGL"
    "OpenGL.GL"
    "OpenGL.GLE"
    "OpenGL.GLU"
  ];

  meta = {
    description = "Python OpenGL bindings";
    homepage = "https://mcfletch.github.io/pyopengl/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
