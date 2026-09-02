{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.16";

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = "olm";
    rev = version;
    sha256 = "sha256-JX20mpuLO+UoNc8iQlXEHAbH9sfblkBbM1gE27Ve0ac=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace olm.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@

    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.4)' \
        'cmake_minimum_required(VERSION 3.10)'
  ''
  + lib.optionalString (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "19") ''
    substituteInPlace include/olm/list.hh \
      --replace-fail "T * const other_pos = other._data;" "T const * other_pos = other._data;"
  '';

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    license = lib.licenses.asl20;
  };
}
