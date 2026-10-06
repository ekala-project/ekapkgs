{
  lib,
  fetchurl,
  nodejs,
  runCommand,
}:

let
  version = "1.14.0";

  # The npm tarball ships no lockfile; vendor one so importNpmLock can resolve
  # the dependency tree offline.
  src = runCommand "openspec-src" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/@fission-ai/openspec/-/openspec-${version}.tgz";
        hash = "sha256-nPFq45qcHiM1D6vFrsoeaX0IAWpQG3E4IpOgSRlnTkQ=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "openspec";
  inherit version src;

  # The published tarball is already built.
  dontNpmBuild = true;

  meta = {
    description = "Spec-driven development for AI coding assistants";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    changelog = "https://github.com/Fission-AI/OpenSpec/releases/tag/v${version}";
    downloadPage = "https://www.npmjs.com/package/@fission-ai/openspec";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    mainProgram = "openspec";
  };
}
