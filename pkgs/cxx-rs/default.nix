{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cxx-rs";
  version = "1.0.194";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cxx";
    tag = finalAttrs.version;
    hash = "sha256-PIeF9VuyJOIs1x02YETKIP0+nCG3RZXLMJdFNlgAFzo=";
  };

  # Upstream doesn't ship a Cargo.lock.
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [
    "--workspace"
    "--exclude=demo"
  ];

  cargoTestFlags = [ "--workspace" ];

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    install -D -m 0644 ./include/cxx.h $dev/include/rust/cxx.h
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "cxxbridge --version";
  };

  meta = {
    description = "Safe FFI between Rust and C++";
    mainProgram = "cxxbridge";
    homepage = "https://github.com/dtolnay/cxx";
    license = with lib.licenses; [
      mit
      asl20
    ];
  };
})
