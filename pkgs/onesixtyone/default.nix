{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "onesixtyone";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "onesixtyone";
    rev = "3bedd7cab7fe1bcfc2def208f87fbf10a013efc7";
    hash = "sha256-9gvulDEaEFZdGl/x5oNHTuMNbBK56dgOydQRyzGO29Q=";
  };

  buildPhase = ''
    $CC -o onesixtyone onesixtyone.c
  '';

  installPhase = ''
    install -D onesixtyone $out/bin/onesixtyone
  '';
  meta = {
    description = "Fast SNMP Scanner";
    homepage = "https://github.com/trailofbits/onesixtyone";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "onesixtyone";
  };
}
