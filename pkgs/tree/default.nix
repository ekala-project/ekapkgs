{
  lib,
  stdenv,
  fetchFromGitLab,
}:

let
  systemFlags =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer -no-cpp-precomp"
      LDFLAGS=
    ''
    + lib.optionalString stdenv.hostPlatform.isCygwin ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=-s
      TREE_DEST=tree.exe
    ''
    + lib.optionalString (stdenv.hostPlatform.isFreeBSD || stdenv.hostPlatform.isOpenBSD) ''
      CFLAGS="-O2 -Wall -fomit-frame-pointer"
      LDFLAGS=-s
    '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tree";
  version = "2.3.2";

  src = fetchFromGitLab {
    owner = "OldManProgrammer";
    repo = "unix-tree";
    rev = finalAttrs.version;
    hash = "sha256-hmnBG96qQXvTulPnUYyliqidfKC+Wvky+d7xzYrCdTw=";
  };

  preConfigure = ''
    makeFlagsArray+=(${systemFlags})
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Command to produce a depth indented directory listing";
    homepage = "https://oldmanprogrammer.net/source.php?dir=projects/tree";
    license = lib.licenses.gpl2Plus;
    mainProgram = "tree";
    platforms = lib.platforms.all;
  };
})
