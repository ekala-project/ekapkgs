{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  bun,
  libseccomp,
  bubblewrap,
  socat,
  ripgrep,
}:

let
  version = "0.0.78";
in
nodejs.buildNpmApplication {
  pname = "sandbox-runtime";
  npmPackName = "@anthropic-ai/sandbox-runtime";
  inherit version;

  src = fetchFromGitHub {
    owner = "anthropic-experimental";
    repo = "sandbox-runtime";
    tag = "v${version}";
    hash = "sha256-ChqWdx8unuXjlg+F7yeBNYK79y7Mf+0aNr/Y5htPBoQ=";
  };

  nativeBuildInputs = [ bun ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libseccomp ];

  # nixpkgs libseccomp ships no static archive; link dynamically (the gcc
  # wrapper injects the store RPATH for buildInputs).
  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace vendor/seccomp/build.ts \
      --replace-fail "['-static', '-O2', '-Wall', '-Wextra']" "['-O2', '-Wall', '-Wextra']"
  '';

  buildPhase = ''
    runHook preBuild
    npm run build --offline
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      bun vendor/seccomp/build.ts
    ''}
    runHook postBuild
  '';

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
    license = lib.licenses.asl20;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "srt";
    platforms = lib.platforms.unix;
  };
}
