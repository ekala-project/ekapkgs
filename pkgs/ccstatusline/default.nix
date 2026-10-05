{
  lib,
  stdenv,
  fetchzip,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "ccstatusline";
  version = "2.2.30";

  src = fetchzip {
    url = "https://registry.npmjs.org/ccstatusline/-/ccstatusline-${version}.tgz";
    hash = "sha256-cfdVpzNb0sa/qYiv/VH3EvNAsxCZDVOG44VVaZQ+vNk=";
  };

  nativeBuildInputs = [ nodejs ];

  installPhase = ''
    runHook preInstall

    # The npm package already contains built files.
    mkdir -p $out/bin
    cp $src/dist/ccstatusline.js $out/bin/ccstatusline
    chmod +x $out/bin/ccstatusline

    substituteInPlace $out/bin/ccstatusline \
      --replace-quiet "#!/usr/bin/env node" "#!${nodejs}/bin/node"

    runHook postInstall
  '';

  meta = {
    description = "Customizable status line formatter for the Claude Code CLI";
    homepage = "https://github.com/sirmalloc/ccstatusline";
    changelog = "https://github.com/sirmalloc/ccstatusline/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "ccstatusline";
    platforms = lib.platforms.all;
  };
}
