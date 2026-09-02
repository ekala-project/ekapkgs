{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
  cmake,
  libsodium,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rosenpass";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rosenpass";
    repo = "rosenpass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i05iIZJX3pvw/9J/rM7UBY9a2YRv25sdJU4duxw0qw8=";
  };

  cargoHash = "sha256-YzPile/lvNMSEgBsKuKhxgv+JnKT3CtuTpfNM8gJctI=";

  nativeBuildInputs = [
    cmake # for oqs build in the oqs-sys crate
    pkg-config
    rustPlatform.bindgenHook # for C-bindings in the crypto libs
    installShellFiles
  ];

  buildInputs = [ libsodium ];

  # nix defaults to building for aarch64 _without_ the armv8-a
  # crypto extensions, but liboqs depends on these
  preBuild = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -march=armv8-a+crypto"
  '';

  postInstall = ''
    installManPage doc/rosenpass.1
  '';
  meta = {
    description = "Build post-quantum-secure VPNs with WireGuard";
    homepage = "https://rosenpass.eu/";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    teams = [ ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "rosenpass";
  };
})
