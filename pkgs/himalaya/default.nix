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
  version = "2.2.1";
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
    hash = "sha256-fYspChAGb0PLdsgP5GViAwp4NdmDXDyait0mpqIkGfQ=";
  };

  cargoHash = "sha256-KDsvF8wHMIEw+rjBJpUTgX6QIhcCMVjLWcPWklpxG3Q=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = lib.optional withOpenssl openssl;

  meta = {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "https://github.com/pimalaya/himalaya/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
}
