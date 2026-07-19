{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfaketime";
  version = "0.9.11";

  src = fetchFromGitHub {
    owner = "wolfcw";
    repo = "libfaketime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a0TjHYzwbkRQyvr9Sj/DqjgLBnE1Z8kjsTQxTfGqLjE=";
  };

  patches = [
    ./nix-store-date.patch
  ];

  postPatch = ''
    patchShebangs test src
    substituteInPlace test/functests/test_exclude_mono.sh src/faketime.c \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace src/faketime.c \
      --replace-fail @DATE_CMD@ ${lib.getExe' coreutils "date"}
  '';

  env = {
    PREFIX = placeholder "out";
    LIBDIRNAME = "/lib";
  };

  nativeCheckInputs = [ perl ];

  doCheck = false;

  __structuredAttrs = true;

  meta = {
    description = "Report faked system time to programs without having to change the system-wide time";
    homepage = "https://github.com/wolfcw/libfaketime/";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "faketime";
  };
})
