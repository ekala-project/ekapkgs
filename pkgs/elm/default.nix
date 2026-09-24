# elm — Elm compiler (pre-built binary)
{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  gmp,
  ncurses,
  zlib,
}:

let
  version = "0.19.2";

  sources = {
    x86_64-linux = {
      url = "https://github.com/elm/compiler/releases/download/${version}/elm-${version}-linux-x64.gz";
      hash = "sha256-ZjINJ3AWVPoRvQ6NhL35gpaU1XcMjc7i3t5hYPrVhzc=";
    };
  };
in
stdenv.mkDerivation {
  pname = "elm";
  inherit version;

  src = fetchurl (
    sources.${stdenv.hostPlatform.system}
      or (throw "elm: unsupported platform ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isElf [
    (lib.getLib stdenv.cc.cc)
    gmp
    ncurses
    zlib
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    zcat $src > $out/bin/elm
    chmod +x $out/bin/elm
    runHook postInstall
  '';

  meta = {
    description = "Compiler for Elm, a functional language for reliable web apps";
    homepage = "https://elm-lang.org/";
    license = lib.licenses.bsd3;
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "elm";
  };
}
