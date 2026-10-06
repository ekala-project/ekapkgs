{
  lib,
  fetchurl,
  makeWrapper,
  nodejs,
  runCommand,
}:

let
  version = "1.7.0";

  src = runCommand "skills-src" { } ''
    mkdir -p $out
    tar -xzf ${
      fetchurl {
        url = "https://registry.npmjs.org/skills/-/skills-${version}.tgz";
        hash = "sha256-jRRm95K6rulF2uiOBe5APW+eeKOujcv2FJYDXKJ0QY0=";
      }
    } -C $out --strip-components=1
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "skills";
  inherit version src;

  dontNpmBuild = true;

  postInstall = ''
    for bin in skills add-skill; do
      wrapProgram $out/bin/$bin --set DISABLE_TELEMETRY 1
    done
  '';

  meta = {
    description = "The open agent skills tool for installing and managing skills across AI coding agents";
    homepage = "https://github.com/vercel-labs/skills";
    changelog = "https://github.com/vercel-labs/skills/releases/tag/v${version}";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "skills";
    platforms = lib.platforms.all;
  };
}
