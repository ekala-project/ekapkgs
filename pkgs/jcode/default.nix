{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jcode";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "jcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m6tZAtr1Kn/bOvK7nSQne6YTO+OHJJOGenczaWWjupM=";
  };

  cargoHash = "sha256-dsMIAytIhLjAS76yfRbPIFgvfresozwi3/9GVQ5cuvc=";

  # .cargo/config.toml caps builds at 4 jobs; let Nix parallelism decide.
  postPatch = ''
    rm .cargo/config.toml
  '';

  # aws-lc-sys (rustls provider) needs cmake; imap's default native-tls backend
  # links against system openssl.
  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ openssl ];

  env.JCODE_RELEASE_BUILD = "1";

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "RAM-efficient coding agent TUI with multi-model support and swarm coordination";
    homepage = "https://github.com/1jehuang/jcode";
    changelog = "https://github.com/1jehuang/jcode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "jcode";
    platforms = lib.platforms.unix;
  };
})
