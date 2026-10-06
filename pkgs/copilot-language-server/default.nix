{
  lib,
  fetchzip,
  nodejs,
  runCommand,
}:

let
  version = "1.551.2";

  src = runCommand "copilot-language-server-src" { } ''
    mkdir -p $out
    cp -r ${
      fetchzip {
        url = "https://registry.npmjs.org/@github/copilot-language-server/-/copilot-language-server-${version}.tgz";
        hash = "sha256-gsqL6zk0M3V9xuvL4NZCa3PreMKe843F+Ms8CgpxwfI=";
      }
    }/* $out/
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "copilot-language-server";
  npmPackName = "@github/copilot-language-server";
  inherit version src;

  # dist/ is prebuilt.
  dontNpmBuild = true;

  meta = {
    description = "GitHub Copilot Language Server - AI pair programmer LSP";
    homepage = "https://github.com/github/copilot-language-server-release";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "copilot-language-server";
    platforms = lib.platforms.all;
  };
}
