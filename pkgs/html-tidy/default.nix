{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libxslt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "html-tidy";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "htacg";
    repo = "tidy-html5";
    rev = finalAttrs.version;
    hash = "sha256-vzVWQodwzi3GvC9IcSQniYBsbkJV20iZanF33A0Gpe0=";
  };

  patches = (
    fetchpatch {
      url = "https://github.com/htacg/tidy-html5/commit/e9aa038bd06bd8197a0dc049380bc2945ff55b29.diff";
      sha256 = "sha256-Q2GjinNBWLL+HXUtslzDJ7CJSTflckbjweiSMCnIVwg=";
    }
  );

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required (VERSION 2.8.12)' 'cmake_minimum_required(VERSION 3.5)'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    libxslt
  ];

  meta = {
    description = "HTML validator and tidier";
    homepage = "http://html-tidy.org";
    license = lib.licenses.libpng;
    platforms = lib.platforms.all;
    mainProgram = "tidy";
  };
})
