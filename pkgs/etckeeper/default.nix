{
  lib,
  stdenv,
  fetchFromGitHub,
  gitMinimal,
  perlPackages,
  python3,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "etckeeper";
  version = "1.17";

  src = fetchFromGitHub {
    owner = "PKRoma";
    repo = "etckeeper";
    tag = finalAttrs.version;
    hash = "sha256-B5ps7oDeKVMbjUdPA1fTdGcyBbupvWZibTZPbGbC07U=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    python3
    perlPackages.perl
  ];

  buildInputs = [
    gitMinimal
    bash
  ];

  makeFlags = [
    "prefix=$(out)"
    "etcdir=$(out)/etc"
    "vardir=$(out)/var"
    "DESTDIR="
    "PYTHON=python3"
  ];

  dontBuild = true;

  meta = {
    description = "Store /etc in git";
    homepage = "https://etckeeper.branchable.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "etckeeper";
  };
})
