{
  lib,
  fetchFromGitHub,
  rustPlatform,
  llvmPackages_19 ? null,
  gitMinimal,
}:

let
  pname = "cargo-llvm-cov";
  version = "0.8.7";

  owner = "taiki-e";
  homepage = "https://github.com/${owner}/${pname}";

  llvm = if llvmPackages_19 != null then llvmPackages_19.llvm else null;
in

rustPlatform.buildRustPackage (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner;
    repo = "cargo-llvm-cov";
    rev = "v${version}";
    sha256 = "sha256-flHZfjwEEIBEJHYGozlRgH9OHTJHgAR+OZxYJS/vHpQ=";
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "test-helper-0.0.0" = "sha256-MjylM9agdGIGMp1Iip/jolHCzErST2XiEl5PIqt+ykg=";
    };
  };

  env = lib.optionalAttrs (llvm != null) {
    LLVM_COV = "${llvm}/bin/llvm-cov";
    LLVM_PROFDATA = "${llvm}/bin/llvm-profdata";
  };

  nativeCheckInputs = [
    gitMinimal
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git init -b main
    git add .
  '';

  checkFlags = [
    "--skip=trybuild"
    "--skip=ui_test"
  ];

  meta = {
    inherit homepage;
    changelog = homepage + "/blob/v${version}/CHANGELOG.md";
    description = "Cargo subcommand to easily use LLVM source-based code coverage";
    mainProgram = "cargo-llvm-cov";
    license = with lib.licenses; [
      asl20
      mit
    ];
  };
})
