{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "vid.stab";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "georgmartius";
    repo = "vid.stab";
    rev = "4bd81e3cdd778e2e0edc591f14bba158ec40cfa1";
    hash = "sha256-imSy1ywpGWbghP65NoPgUJBJmHUY5OsLWmIXk6Q1MQ4=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required (VERSION 2.8.5)' \
        'cmake_minimum_required (VERSION 3.10)'
  '';

  meta = {
    description = "Video stabilization library";
    homepage = "http://public.hronopik.de/vid.stab/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
