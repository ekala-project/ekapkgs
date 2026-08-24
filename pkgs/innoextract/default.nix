{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  xz,
}:

stdenv.mkDerivation {
  pname = "innoextract";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "dscharrer";
    repo = "innoextract";
    rev = "6e9e34ed0876014fdb46e684103ef8c3605e382e";
    hash = "sha256-bgACPDo1phjIiwi336JEB1UAJKyL2NmCVOhyZxBFLJo=";
  };

  buildInputs = [
    xz
    boost
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  strictDeps = true;

  meta = {
    description = "Tool to unpack installers created by Inno Setup";
    homepage = "https://constexpr.org/innoextract/";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "innoextract";
  };
}
