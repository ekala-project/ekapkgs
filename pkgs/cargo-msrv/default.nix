{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rustup ? null,
  openssl,
  stdenv,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-msrv";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "cargo-msrv";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-qt1Mlj4/DSh8V/SkgorLJFRdLwbtXyOvrISU1vmXzyg=";
  };

  cargoHash = "sha256-cqTSLpmS/9BgtuVXlqBrxpFCPPs+wFhqOalOVhPD5r8=";

  # Integration tests fail
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  postInstall = lib.optionalString (rustup != null) ''
    wrapProgram $out/bin/cargo-msrv --prefix PATH : ${lib.makeBinPath [ rustup ]};
  '';

  meta = {
    description = "Cargo subcommand \"msrv\": assists with finding your minimum supported Rust version (MSRV)";
    mainProgram = "cargo-msrv";
    homepage = "https://github.com/foresterre/cargo-msrv";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
