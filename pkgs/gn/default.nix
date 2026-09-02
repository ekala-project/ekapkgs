{
  stdenv,
  lib,
  fetchgit,
  fetchpatch,
  writeText,
  ninja,
  python3,
}:

let
  rev = "df98b86690c83b81aedc909ded18857296406159";
  revNum = "2168";
  version = "2024-05-13";
  revShort = builtins.substring 0 7 rev;
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM ${revNum}
    #define LAST_COMMIT_POSITION "${revNum} (${revShort})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';
in
stdenv.mkDerivation {
  pname = "gn-unstable";
  inherit version;

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev;
    hash = "sha256-mNoQeHSSM+rhR0UHrpbyzLJC9vFqfxK1SD0X8GiRsqw=";
  };

  patches = [
    (fetchpatch {
      name = "LFS64.patch";
      url = "https://gn.googlesource.com/gn/+/b5ff50936a726ff3c8d4dfe2a0ae120e6ce1350d%5E%21/?format=TEXT";
      decode = "base64 -d";
      hash = "sha256-/kh8t/Ip1EG2OIhydS//st/C80KJ4P31vGx7j8QpFh0=";
    })
  ];

  nativeBuildInputs = [
    ninja
    python3
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  buildPhase = ''
    python build/gen.py --no-last-commit-position
    ln -s ${lastCommitPosition} out/last_commit_position.h
    ninja -j $NIX_BUILD_CORES -C out gn
  '';

  installPhase = ''
    install -vD out/gn "$out/bin/gn"
  '';

  setupHook = ./setup-hook.sh;

  meta = {
    description = "Meta-build system that generates build files for Ninja";
    mainProgram = "gn";
    homepage = "https://gn.googlesource.com/gn";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
  };
}
