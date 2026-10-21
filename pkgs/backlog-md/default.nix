{
  lib,
  stdenv,
  fetchFromGitHub,
  bun,
  jq,
}:

bun.buildPackage {
  pname = "backlog-md";
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "MrLesk";
    repo = "Backlog.md";
    tag = "v1.53.0";
    hash = "sha256-NFI59EXjmux1ZgP5KSv7zKhhnaJtMBERQYxHXatm31U=";
  };

  node_modulesHash = "sha256-FWD+2HrGziyfDpfGPABaj89Pf6YQ41oc8owLXFDmbBs=";
  node_modulesAttrs = {
    nativeBuildInputs = [
      bun
      jq
    ];
    postPatch = ''
      ${lib.getExe jq} '
        if .dependencies    then .dependencies    |= with_entries(.value |= ltrimstr("^") | .value |= ltrimstr("~")) else . end |
        if .devDependencies then .devDependencies |= with_entries(.value |= ltrimstr("^") | .value |= ltrimstr("~")) else . end
      ' package.json > package.json.tmp && mv package.json.tmp package.json
      sed -i 's/: "\^/: "/g; s/: "~/: "/g' bun.lock
    '';
  };

  preBuild = ''
    export LD_LIBRARY_PATH="${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
  '';

  bunBuildCommand = ''
    bun scripts/build.ts
  '';

  dontStrip = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dist/backlog $out/bin/backlog
    runHook postInstall
  '';

  doInstallCheck = false;

  meta = {
    description = "Manage project collaboration between humans and AI agents in a git ecosystem";
    homepage = "https://github.com/MrLesk/Backlog.md";
    changelog = "https://github.com/MrLesk/Backlog.md/releases";
    license = lib.licenses.mit;
    mainProgram = "backlog";
    platforms = lib.platforms.unix;
  };
}
