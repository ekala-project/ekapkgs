{
  lib,
  stdenv,
  runCommand,
  fetchFromGitHub,
  makeWrapper,
  bun,
  bashInteractive,
  claude-code,
  gitMinimal,
  ripgrep,
  fd,
  coreutils,
  grep,
  sed,
  gawk,
  findutils,
  which,
  tree,
  curl,
  wget,
  jq,
  less,
  zsh,
  nix,
  bubblewrap,
  sourceDir ? null,
}:

let
  claudeboxSource = fetchFromGitHub {
    owner = "numtide";
    repo = "claudebox";
    rev = "v0.2.0";
    hash = "sha256-4C+e9K0Mq+OfBIH9u/EdzrtXLXVqWBfndAC2BHU+JhE=";
  };

  resolvedSourceDir = if sourceDir != null then sourceDir else "${claudeboxSource}/src";

  inherit (stdenv.hostPlatform) isLinux;

  claudeTools = stdenv.mkDerivation {
    name = "claude-tools";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      for t in ${lib.makeBinPath [
        gitMinimal
        ripgrep
        fd
        coreutils
        grep
        sed
        gawk
        findutils
        which
        tree
        curl
        wget
        jq
        less
        zsh
        nix
      ]}; do
        for f in "$t"/*; do
          [ -e "$f" ] && ln -sf "$f" "$out/bin/$(basename "$f")"
        done
      done
    '';
  };

  sandboxTools = lib.optionals isLinux [ bubblewrap ];
  seatbeltProfile = "${resolvedSourceDir}/seatbelt.sbpl";
in
runCommand "claudebox"
  {
    buildInputs = [ makeWrapper ];
    passthru.category = "Sandboxing & Isolation";
    meta = {
      mainProgram = "claudebox";
      description = "Sandboxed environment for Claude Code";
      homepage = "https://github.com/numtide/claudebox";
      changelog = "https://github.com/numtide/claudebox/releases";
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
  ''
    mkdir -p $out/bin $out/share/claudebox $out/libexec/claudebox

    cp ${resolvedSourceDir}/claudebox.js $out/libexec/claudebox/claudebox.js
    cp ${seatbeltProfile} $out/share/claudebox/seatbelt.sbpl

    makeWrapper ${bun}/bin/bun $out/bin/claudebox \
      --add-flags $out/libexec/claudebox/claudebox.js \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            bashInteractive
            claudeTools
          ]
          ++ sandboxTools
        )
      } \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "--set CLAUDEBOX_SEATBELT_PROFILE $out/share/claudebox/seatbelt.sbpl"}

    makeWrapper ${claude-code}/bin/.claude-wrapped $out/libexec/claudebox/claude \
      --set DISABLE_AUTOUPDATER 1 \
      --inherit-argv0
  ''
