{
  lib,
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  fetchFromGitHub,
  installShellFiles,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

let
  version = "2.0.0";
  withOpenssl = stdenv.hostPlatform.isLinux && builtins.elem "native-tls" buildFeatures;
in
rustPlatform.buildRustPackage {
  inherit
    version
    buildFeatures
    buildNoDefaultFeatures
    ;

  pname = "himalaya";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "himalaya";
    rev = "v${version}";
    hash = "sha256-rOCMjJV0lFSIlvstkSMqGwXKDZsBkWtTYhvXpA73ucA=";
  };

  cargoHash = "sha256-ppZYlGWNS5lXQZNt7RcwJIvU5jp07cXhEpmFJ9UtxRE=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional withOpenssl openssl;

  postInstall = ''
    mkdir -p $out/share/{applications,completions,man,schemas}
    cp assets/himalaya.desktop "$out"/share/applications/
  '';

  meta = {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "https://github.com/pimalaya/himalaya/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
