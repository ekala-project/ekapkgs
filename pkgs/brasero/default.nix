{
  lib,
  symlinkJoin,
  brasero-unwrapped,
  cdrtools,
  libdvdcss,
  makeWrapper,
}:

let
  binPath = lib.makeBinPath [ cdrtools ];
in
symlinkJoin {
  pname = "brasero";
  inherit (brasero-unwrapped) meta version;

  paths = [ brasero-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/brasero \
      --prefix PATH ':' ${binPath} \
      --prefix LD_PRELOAD : ${lib.makeLibraryPath [ libdvdcss ]}/libdvdcss.so
  '';
}
