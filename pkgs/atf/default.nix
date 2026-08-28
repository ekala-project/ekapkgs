{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atf";
  version = "0.23";

  src = fetchFromGitHub {
    owner = "freebsd";
    repo = "atf";
    tag = "atf-${finalAttrs.version}";
    hash = "sha256-g9cXeiCaiyGQXtg6eyrbRQpqk4VLGSFuhfPB+ynbDIo=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace atf-c/detail/fs_test.c \
      --replace-fail 'ATF_TP_ADD_TC(tp, eaccess);' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  makeFlags = [
    # ATF isn't compatible with C++17, which is the default on current clang and GCC.
    "CXXFLAGS=-std=c++14"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Libraries to write tests in C, C++, and shell";
    homepage = "https://github.com/freebsd/atf/";
    license = lib.licenses.bsd3;
    mainProgram = "atf-sh";
    platforms = lib.platforms.unix;
  };
})
