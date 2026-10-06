{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  nodejs,
  runCommand,
  bubblewrap,
  socat,
  ripgrep,
}:

let
  version = "0.0.78";

  src = runCommand "sandbox-runtime-src" { } ''
    mkdir -p $out
    cp -r ${
      fetchzip {
        url = "https://registry.npmjs.org/@anthropic-ai/sandbox-runtime/-/sandbox-runtime-${version}.tgz";
        hash = "sha256-kKN3xFXp+7Z+I/wUew2v+1lnYRwkViGajiLqoCgLrp0=";
      }
    }/* $out/
    cp ${./package-lock.json} $out/package-lock.json
  '';
in
nodejs.buildNpmApplication {
  pname = "sandbox-runtime";
  npmPackName = "@anthropic-ai/sandbox-runtime";
  inherit version src;

  dontNpmBuild = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/srt \
      --suffix PATH : ${
        lib.makeBinPath [
          bubblewrap
          socat
          ripgrep
        ]
      }
  '';

  meta = {
    description = "Lightweight sandboxing tool for enforcing filesystem and network restrictions";
    longDescription = ''
      Anthropic Sandbox Runtime (srt) is a lightweight sandboxing tool for
      enforcing filesystem and network restrictions on arbitrary processes at
      the OS level, without requiring a container.
    '';
    homepage = "https://github.com/anthropic-experimental/sandbox-runtime";
    changelog = "https://github.com/anthropic-experimental/sandbox-runtime/releases";
    downloadPage = "https://www.npmjs.com/package/@anthropic-ai/sandbox-runtime";
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "srt";
    platforms = lib.platforms.unix;
  };
}
