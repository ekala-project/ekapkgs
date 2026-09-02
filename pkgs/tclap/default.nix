{
  lib,
  stdenv,
  fetchgit,
  cmake,
  doxygen,
  python3,
}:

stdenv.mkDerivation {
  pname = "tclap";
  version = "1.4-3feeb7b";

  src = fetchgit {
    url = "git://git.code.sf.net/p/tclap/code";
    rev = "3feeb7b2499b37d9cb80890cadaf7c905a9a50c6";
    hash = "sha256-byLianB6Vf+I9ABMmsmuoGU2o5RO9c5sMckWW0F+GDM=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace '$'{CMAKE_INSTALL_LIBDIR_ARCHIND} '$'{CMAKE_INSTALL_LIBDIR}
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    doxygen
    python3
  ];

  preInstall = ''
    touch docs/manual.html
  '';

  doCheck = true;

  meta = {
    description = "Templatized C++ Command Line Parser Library (v1.4)";
    homepage = "https://tclap.sourceforge.net/";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
