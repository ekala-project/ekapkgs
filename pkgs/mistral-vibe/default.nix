{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  fetchPypi,
  fetchurl,
  callPackage,
  rustPlatform,
  cargo,
  rustc,
  maturin,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  versionData = builtins.fromJSON (builtins.readFile ./hashes.json);
  inherit (versionData) version hashes;

  wheelPlatforms = {
    x86_64-linux = "manylinux_2_28_x86_64";
    aarch64-linux = "manylinux_2_28_aarch64";
    aarch64-darwin = "macosx_11_0_arm64";
  };

  wheelUrl = "https://files.pythonhosted.org/packages/cp312/m/mistral_vibe/mistral_vibe-{version}-cp312-abi3-{platform}.whl";

  textual-speedups = python3.pkgs.buildPythonPackage rec {
    pname = "textual-speedups";
    version = "0.2.1";
    pyproject = true;

    src = fetchPypi {
      pname = "textual_speedups";
      inherit version;
      hash = "sha256-cs8Pe97t4BU2e1m3C89yS6LDCAqGQevF65SzatFTaCQ=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-Bz4ocEziOlOX4z5F9EDry99YofeGyxL/6OTIf/WEgK4=";
    };

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
      cargo
      rustc
      maturin
    ];

    pythonImportsCheck = [ "textual_speedups" ];

    meta = {
      description = "Optional Rust speedups for Textual TUI framework";
      homepage = "https://github.com/willmcgugan/textual-speedups";
      license = lib.licenses.mit;
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      platforms = lib.platforms.all;
    };
  };

  tree-sitter-bash = python3.pkgs.buildPythonPackage rec {
    pname = "tree-sitter-bash";
    version = "0.25.1";
    pyproject = true;

    src = fetchPypi {
      pname = "tree_sitter_bash";
      inherit version;
      hash = "sha256-v8C9qne8HobjxmUuWm4UDEDAoWuEGFwrY6182Am4jxQ=";
    };

    build-system = with python3.pkgs; [ setuptools ];

    pythonImportsCheck = [ "tree_sitter_bash" ];

    meta = {
      description = "Bash grammar for tree-sitter";
      homepage = "https://github.com/tree-sitter/tree-sitter-bash";
      license = lib.licenses.mit;
      sourceProvenance = [ lib.sourceTypes.fromSource ];
      platforms = lib.platforms.all;
    };
  };

  otelVersion = "1.40.0";
  otelContribVersion = "0.61b0";
  otelSrc = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    tag = "v${otelVersion}";
    hash = "sha256-1KVy9s+zjlB4w7E45PMCWRxPus24bgBmmM3k2R9d+Jg=";
  };
  otelContribSrc = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    tag = "v${otelContribVersion}";
    hash = "sha256-DT13gcYPNYXBPnf622WsA16C+7sabJfOshDquHn06Ok=";
  };

  python = python3.override {
    self = python;
    packageOverrides = _pyfinal: pyprev: {
      inherit textual-speedups tree-sitter-bash;

      textual = pyprev.textual.overridePythonAttrs (old: rec {
        version = "8.2.7";
        src = old.src.override {
          tag = "v${version}";
          hash = "sha256-jRTdxVpeRk8gAur5+VpLVVghBdYenXysoEFRBfczkR4=";
        };
      });

      pydantic-settings = pyprev.pydantic-settings.overridePythonAttrs (_: rec {
        version = "2.14.2";
        src = fetchPypi {
          pname = "pydantic_settings";
          inherit version;
          hash = "sha256-wZ3WSxkJfx3oAYTwzHsCcqE65uFwy/JAo+J+OB7RSl8=";
        };
      });

      mistralai = callPackage ./mistralai.nix { python3 = python; };
      agent-client-protocol = callPackage ./agent-client-protocol.nix { python3 = python; };

      opentelemetry-api = pyprev.opentelemetry-api.overridePythonAttrs (_: {
        version = otelVersion;
        src = otelSrc;
        sourceRoot = "${otelSrc.name}/opentelemetry-api";
      });

      opentelemetry-exporter-otlp-proto-http =
        pyprev.opentelemetry-exporter-otlp-proto-http.overridePythonAttrs
          (old: {
            disabledTests = (old.disabledTests or [ ]) ++ [
              "test_retry_timeout"
              "test_shutdown_interrupts_retry_backoff"
            ];
          });

      opentelemetry-instrumentation = pyprev.opentelemetry-instrumentation.overridePythonAttrs (_: {
        version = otelContribVersion;
        src = otelContribSrc;
        sourceRoot = "${otelContribSrc.name}/opentelemetry-instrumentation";
      });

      opentelemetry-semantic-conventions =
        pyprev.opentelemetry-semantic-conventions.overridePythonAttrs
          (_: {
            version = otelContribVersion;
          });
    };
  };
in
python.pkgs.buildPythonApplication {
  pname = "mistral-vibe";
  inherit version;
  format = "wheel";

  src = fetchurl {
    url =
      builtins.replaceStrings
        [ "{version}" "{platform}" ]
        [
          version
          wheelPlatforms.${stdenv.hostPlatform.system}
        ]
        wheelUrl;
    hash = hashes.${stdenv.hostPlatform.system};
  };

  # `import vibe` creates ~/.vibe during pythonImportsCheck; HOME must be writable.
  env.HOME = "/build";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dependencies = with python.pkgs; [
    agent-client-protocol
    anyio
    cachetools
    cryptography
    gitpython
    giturlparse
    google-auth
    httpx
    humanize
    jsonpatch
    keyring
    markdownify
    mcp
    miniaudio
    mistralai
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    packaging
    pexpect
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    pyyaml
    requests
    rfc8785
    rich
    sentry-sdk
    setproctitle
    sounddevice
    textual
    textual-speedups
    tomli-w
    tree-sitter
    tree-sitter-bash
    truststore
    watchfiles
    websockets
    zstandard
  ];

  pythonRelaxDeps = true;

  pythonImportsCheck = [
    "vibe"
    "vibe.cli.cli"
    "vibe.app_server.local"
    "vibe.core.llm.backend.mistral"
    "vibe.cli.transcribe.mistral_transcribe_client"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "--version" ];

  meta = {
    description = "Minimal CLI coding agent by Mistral AI - open-source command-line coding assistant powered by Devstral";
    homepage = "https://github.com/mistralai/mistral-vibe";
    changelog = "https://github.com/mistralai/mistral-vibe/releases/tag/v${version}";
    license = lib.licenses.asl20;
    sourceProvenance = [
      lib.sourceTypes.fromSource
      lib.sourceTypes.binaryNativeCode
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "vibe";
  };
}
