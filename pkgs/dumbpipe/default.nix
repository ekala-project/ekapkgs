{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dumbpipe";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AoWWFlMjo1bZUq5RY4gjpEMydULHaCKSSxBh45a7pdI=";
  };

  cargoHash = "sha256-je2/GjCCDymYGhho6yf7SNQ3YkLCLQ5nEqHPNdDXjbQ=";

  checkFlags = [
    "--skip=connect_listen_ctrlc_connect"
    "--skip=connect_listen_ctrlc_listen"
    "--skip=connect_tcp_happy"
    "--skip=unix_socket_tests::unix_socket_roundtrip"
  ];

  meta = {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "dumbpipe";
  };
})
