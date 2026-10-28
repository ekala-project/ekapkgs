{
  lib,
  stdenv,
  fetchurl,
  ncurses,
  alsa-lib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "festival";
  version = "2.5.0";

  src = fetchurl {
    url = "http://festvox.org/packed/festival/${lib.versions.majorMinor finalAttrs.version}/festival-${finalAttrs.version}-release.tar.gz";
    hash = "sha256-TJAHQmsSUpBZnZMd9BDi3vUeaKiu69ibSmHHyWwJpLQ=";
  };

  speechTools = fetchurl {
    url = "http://festvox.org/packed/festival/${lib.versions.majorMinor finalAttrs.version}/speech_tools-${finalAttrs.version}-release.tar.gz";
    hash = "sha256-5P2X7XjxRGQ1jQnzbf6RvBcht8D6ZQPgQ2T7WEeAXcw=";
  };

  nativeBuildInputs = [ pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-fcommon -Wno-error=implicit-int -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types";

  buildInputs = [
    ncurses
    alsa-lib
  ];

  unpackPhase = ''
    tar xzf $src
    tar xzf $speechTools
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    export FESTIVAL_HOME=$(pwd)/festival
    export EST=$(pwd)/speech_tools

    cd speech_tools
    # Fix hardcoded paths that don't exist in the sandbox
    sed -i 's|/usr/bin/printf "%s"|echo -n|' config/systems/Linux.mak
    sed -i 's|/bin/rm|rm|' config/systems/default.mak
    ./configure
    make
    cd ..

    cd festival
    rm -f config.cache
    ./configure --prefix=$out || { cat config.log; exit 1; }
    make
    cd ..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib $out/share/festival
    cp -rL festival/bin/* $out/bin/
    cp -rL festival/lib/* $out/lib/
    cp -rL speech_tools/bin/* $out/bin/
    cp -rL speech_tools/lib/* $out/lib/
    runHook postInstall
  '';

  meta = {
    description = "General multi-lingual speech synthesis system";
    homepage = "http://festvox.org/festival/";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    mainProgram = "festival";
  };
})
