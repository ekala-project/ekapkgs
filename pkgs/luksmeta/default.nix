{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  cryptsetup,
}:

stdenv.mkDerivation rec {
  pname = "luksmeta";
  version = "11";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "luksmeta";
    tag = "v${version}";
    hash = "sha256-GN1RDcSKRHuUpKLnn53r57GrNfOfwfgdQzDWyCX0npk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ cryptsetup ];

  meta = {
    description = "Simple library for storing metadata in the LUKSv1 header";
    mainProgram = "luksmeta";
    homepage = "https://github.com/latchset/luksmeta/";
    license = lib.licenses.lgpl21Plus;
  };
}
