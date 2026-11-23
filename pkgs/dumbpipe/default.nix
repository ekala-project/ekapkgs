{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dumbpipe";
  version = "0.40.2";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "dumbpipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/TEc0l2PpGgF17FQwpcSKhyLm3lsLY/9X8Ar7Jy3S9s=";
  };

  cargoHash = "sha256-RXiYFMfH9SaTXf6MbwPJCl4JkGphfMUdUtOLyoZ1hNI=";

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
    mainProgram = "dumbpipe";
  };
})
