{
  lib,
  stdenv,
  stdenvNoCC,
  buildGoModule,
  go,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  fetchurl,
  nodejs,
  claude-code ? null,
  codex ? null,
  gemini-cli ? null,
  pi ? null,
  omp ? null,
  opencode ? null,
  copilot-cli ? null,
  hermes-agent ? null,
  amp ? null,
  cursor-agent ? null,
  droid ? null,
  grok ? null,
  kilocode-cli ? null,
  kimi-code ? null,
  qoder-cli ? null,
  qwen-code ? null,
  claudeSupport ? false,
  codexSupport ? false,
  geminiSupport ? false,
  piSupport ? false,
  ompSupport ? false,
  opencodeSupport ? false,
  copilotSupport ? false,
  hermesSupport ? false,
  ampSupport ? false,
  cursorSupport ? false,
  droidSupport ? false,
  grokSupport ? false,
  kilocodeSupport ? false,
  kimiSupport ? false,
  qoderSupport ? false,
  qwenSupport ? false,
  extraPackages ? [ ],
  makeWrapper,
  rcodesign ? null,
  gitMinimal,
  bash,
  openssh,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pname = "kandev";
  version = "0.96.0";

  src = fetchFromGitHub {
    owner = "kdlbs";
    repo = "kandev";
    tag = "v${version}";
    hash = "sha256-RqyV4wcgyW3OFrdvIBOq5HiWPPofLah2pNEWvpCrvos=";
  };

  runtimeTools = [
    nodejs
    gitMinimal
    bash
    openssh
  ];
  agentRuntimePackages =
    runtimeTools
    ++ lib.optional claudeSupport claude-code
    ++ lib.optional codexSupport codex
    ++ lib.optional geminiSupport gemini-cli
    ++ lib.optional piSupport pi
    ++ lib.optional ompSupport omp
    ++ lib.optional opencodeSupport opencode
    ++ lib.optional copilotSupport copilot-cli
    ++ lib.optional hermesSupport hermes-agent
    ++ lib.optional ampSupport amp
    ++ lib.optional cursorSupport cursor-agent
    ++ lib.optional droidSupport droid
    ++ lib.optional grokSupport grok
    ++ lib.optional kilocodeSupport kilocode-cli
    ++ lib.optional kimiSupport kimi-code
    ++ lib.optional qoderSupport qoder-cli
    ++ lib.optional qwenSupport qwen-code
    ++ extraPackages;
  agentRuntimeCommands = [
    "node"
    "git"
    "bash"
    "ssh"
  ]
  ++ lib.optional claudeSupport "claude"
  ++ lib.optional codexSupport "codex"
  ++ lib.optional geminiSupport "gemini"
  ++ lib.optional piSupport "pi"
  ++ lib.optional ompSupport "omp"
  ++ lib.optional opencodeSupport "opencode"
  ++ lib.optional copilotSupport "copilot"
  ++ lib.optional hermesSupport "hermes"
  ++ lib.optional ampSupport "amp"
  ++ lib.optional cursorSupport "cursor-agent"
  ++ lib.optional droidSupport "droid"
  ++ lib.optional grokSupport "grok"
  ++ lib.optional kilocodeSupport "kilocode"
  ++ lib.optional kimiSupport "kimi"
  ++ lib.optional qoderSupport "qodercli"
  ++ lib.optional qwenSupport "qwen";
  agentPath = lib.makeBinPath agentRuntimePackages;
  agentRuntimeEnvironment =
    lib.optionalAttrs claudeSupport {
      CLAUDE_CODE_EXECUTABLE = lib.getExe claude-code;
    }
    // lib.optionalAttrs codexSupport {
      CODEX_PATH = lib.getExe codex;
    };
  agentRuntimeWrapperArgs = lib.concatLists (
    lib.mapAttrsToList (name: value: [
      "--set"
      name
      value
    ]) agentRuntimeEnvironment
  );

  # All platforms the agentctl helper is cross-compiled for.  The host
  # target is built natively; the remaining three are built with CGO off.
  agentctlTargets = [
    {
      goos = "linux";
      goarch = "amd64";
    }
    {
      goos = "linux";
      goarch = "arm64";
    }
    {
      goos = "darwin";
      goarch = "arm64";
    }
    {
      goos = "darwin";
      goarch = "amd64";
    }
  ];
  hostTarget = {
    goos = go.GOOS;
    goarch = go.GOARCH;
  };
  crossTargets = builtins.filter (t: t != hostTarget) agentctlTargets;
  agentctlName = t: "agentctl-${t.goos}-${t.goarch}";

  pnpm9 = pnpm.v10.overrideAttrs (_: {
    version = "9.15.9";
    src = fetchurl {
      url = "https://registry.npmjs.org/pnpm/-/pnpm-9.15.9.tgz";
      hash = "sha256-z4anrXZEBjldQoam0J1zBxFyCsxtk+nc6ax6xNxKKKc=";
    };
  });

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "kandev-web";
    inherit version src;

    sourceRoot = "${src.name}/apps";

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      pnpm = pnpm9;
      fetcherVersion = 3;
      hash = "sha256-Ec1iLQxA2UUIoLef5OC9qh+I/gS2DOLYW2RSmL0zV+c=";
    };

    nativeBuildInputs = [
      nodejs
      pnpm9
      pnpmConfigHook
    ];

    buildPhase = ''
      runHook preBuild
      chmod -R u+w node_modules 2>/dev/null || true
      patchShebangs node_modules 2>/dev/null || true
      for d in $PWD/node_modules/.bin; do export PATH="$d:$PATH"; done
      KANDEV_VERSION=${version} VITE_KANDEV_API_PORT= VITE_KANDEV_DEBUG= \
        pnpm --filter @kandev/web build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      cp -r web/dist $out
      runHook postInstall
    '';
  });
in
buildGoModule (_finalAttrs: {
  inherit pname version src;

  modRoot = "apps/backend";
  vendorHash = "sha256-/SwR/yZcQ4wiRj+Wiz5nSzmozHKv++gbeYJmJlD6168=";
  overrideModAttrs = _: _: {
    patches = [ ];
    postPatch = "";
  };

  subPackages = [
    "cmd/kandev"
    "cmd/agentctl"
  ];

  tags = [ "fts5" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${version}"
  ];

  patches = [ ./prefer-native-acp-runtimes.patch ];

  postPatch = ''
    substituteInPlace apps/backend/internal/agent/agents/{devin,goose,muse}_acp_test.go \
      --replace-fail '":/usr/bin:/bin"' '":" + os.Getenv("PATH")'
  '';

  preBuild = ''
    generated=internal/webapp/embedded/generated
    find "$generated" -mindepth 1 ! -name .gitignore ! -name keep.txt -exec rm -rf {} +
    cp -r ${frontend}/. "$generated/"
  '';

  postBuild = ''
    helper_ldflags="-s -w"
  ''
  + lib.concatMapStrings (t: ''
    env CGO_ENABLED=0 GOOS=${t.goos} GOARCH=${t.goarch} \
      go build -ldflags "$helper_ldflags" -o ${agentctlName t} ./cmd/agentctl
  '') crossTargets;

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    mkdir -p $out/libexec/kandev/bin
    mv $out/bin/kandev $out/bin/agentctl $out/libexec/kandev/bin/
    # The native agentctl is already at $out/libexec/kandev/bin/agentctl;
    # symlink the host-specific name to it.
    ln -s agentctl "$out/libexec/kandev/bin/${agentctlName hostTarget}"
  ''
  + lib.concatMapStrings (t: ''
    install -Dm755 ${agentctlName t} $out/libexec/kandev/bin/${agentctlName t}
  '') crossTargets
  + ''

    makeWrapper $out/libexec/kandev/bin/kandev $out/bin/kandev \
      --set KANDEV_BUNDLE_DIR $out/libexec/kandev \
      --set KANDEV_VERSION ${version} \
      ${lib.escapeShellArgs agentRuntimeWrapperArgs} \
      --prefix PATH : ${agentPath}
  '';

  dontStrip = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    go test ./internal/agent/agents ./internal/agentctl/server/utility
    runHook postCheck
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
    nodejs
  ];
  versionCheckProgramArg = "--version";

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/kandev --help >/dev/null
    set +e
    output="$($out/libexec/kandev/bin/agentctl kandev 2>&1)"
    status=$?
    set -e
    test "$status" -eq 1
    grep -F "Usage: agentctl kandev" <<<"$output"

    helpers="${lib.concatMapStringsSep " " agentctlName agentctlTargets}"
    for helper in $helpers; do
      test -e "$out/libexec/kandev/bin/$helper"
    done

    runHook postInstallCheck
  '';

  passthru = {
    inherit
      agentPath
      agentRuntimePackages
      agentRuntimeCommands
      agentRuntimeEnvironment
      agentRuntimeWrapperArgs
      frontend
      ;
  };

  meta = {
    description = "Manage tasks, orchestrate agents, review changes, and ship value";
    homepage = "https://github.com/kdlbs/kandev";
    changelog = "https://github.com/kdlbs/kandev/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "kandev";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
