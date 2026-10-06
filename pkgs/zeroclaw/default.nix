{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  nodejs,
  importNpmLock,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pname = "zeroclaw";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "zeroclaw-labs";
    repo = "zeroclaw";
    tag = "v${version}";
    hash = "sha256-X+2hSmbGibS0LJDew+CnXpJFW2k7w3fj/D54XHqLLzI=";
  };

  # fetchNpmDeps needs package-lock.json at the source root.
  frontendSrc = runCommand "${pname}-web-src-${version}" { } ''
    mkdir -p $out
    cp -r ${src}/web/. $out/
  '';
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-a0tr5K6KReLRRN4X8sjJrriHy/n0LC7amlOHtM765eg=";

  nativeBuildInputs = [
    nodejs
    importNpmLock.npmConfigHook
  ];

  env = {
    NIX_NPM_FETCHER_VERSION = "2";
    "CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_LINKER" =
      "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  };

  npmDeps = importNpmLock.importNpmLock {
    npmRoot = frontendSrc;
  };
  npmRoot = "web";
  makeCacheWritable = true;

  # gen-api renders the gateway's OpenAPI spec and generates the TS API
  # modules the frontend imports; the gateway embeds web/dist via include_dir!.
  preBuild = ''
    cargo run --offline -p xtask --bin web -- gen-api
    npm --prefix web run build
  '';

  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Fast, small, and fully autonomous AI assistant infrastructure";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    changelog = "https://github.com/zeroclaw-labs/zeroclaw/releases/tag/v${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    mainProgram = "zeroclaw";
    platforms = lib.platforms.unix;
  };
}
