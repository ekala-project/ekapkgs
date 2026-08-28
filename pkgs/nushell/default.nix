{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  zstd,
  pkg-config,
  python3,
  libx11,
  withDefaultFeatures ? true,
  additionalFeatures ? (p: p),
}:

rustPlatform.buildRustPackage {
  pname = "nushell";
  version = "0.110.0";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    tag = "0.110.0";
    hash = "sha256-iytTJZ70kg2Huwj/BSwDX4h9DVDTlJR2gEHAB2pGn/k=";
  };

  cargoHash = "sha256-a/N0a9ZVqXAjAl5Z7BdEsIp0He3h0S/owS0spEPb3KI=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ python3 ];

  buildInputs = [
    zstd
  ]
  ++ lib.optionals (withDefaultFeatures && stdenv.hostPlatform.isLinux) [ libx11 ];

  buildNoDefaultFeatures = !withDefaultFeatures;
  buildFeatures = additionalFeatures [ ];

  preCheck = ''
    export NU_TEST_LOCALE_OVERRIDE="en_US.UTF-8"
  '';

  checkPhase = ''
    runHook preCheck
    (
      set -x
      HOME=$(mktemp -d) cargo test -j $NIX_BUILD_CORES --offline -- \
        --test-threads=$NIX_BUILD_CORES \
        --skip=repl::test_config_path::test_default_config_path \
        --skip=repl::test_config_path::test_xdg_config_bad \
        --skip=repl::test_config_path::test_xdg_config_empty
    )
    runHook postCheck
  '';

  checkInputs = lib.optionals stdenv.hostPlatform.isLinux [ openssl ];

  passthru = {
    shellPath = "/bin/nu";
  };

  meta = {
    description = "Modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = lib.licenses.mit;
    mainProgram = "nu";
  };
}
