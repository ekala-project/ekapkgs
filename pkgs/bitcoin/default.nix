{
  lib,
  stdenv,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  installShellFiles,
  boost,
  libevent,
  zeromq,
  zlib,
  sqlite,
  qrencode,
  capnproto,
  python3,
  withGui ? true,
  qt6,
  withWallet ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "bitcoin" else "bitcoind";
  version = "31.1";

  src = fetchurl {
    urls = [
      "https://bitcoincore.org/bin/bitcoin-core-${finalAttrs.version}/bitcoin-${finalAttrs.version}.tar.gz"
    ];
    sha256 = "50411d5b43c7e4c90099394759eb6c2add6e7c2dbe728840893d638b6fc6afc9";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals withGui [ qt6.wrapQtAppsHook ];

  buildInputs = [
    boost
    libevent
    zeromq
    zlib
    capnproto
  ]
  ++ lib.optionals withWallet [ sqlite ]
  ++ lib.optionals withGui [
    qrencode
    qt6.qtbase
    qt6.qttools
  ];

  postInstall = ''
    cd ..
    installShellCompletion --bash contrib/completions/bash/bitcoin-cli.bash
    installShellCompletion --bash contrib/completions/bash/bitcoind.bash
    installShellCompletion --bash contrib/completions/bash/bitcoin-tx.bash

    installShellCompletion --fish contrib/completions/fish/bitcoin-cli.fish
    installShellCompletion --fish contrib/completions/fish/bitcoind.fish
    installShellCompletion --fish contrib/completions/fish/bitcoin-tx.fish
    installShellCompletion --fish contrib/completions/fish/bitcoin-util.fish
    installShellCompletion --fish contrib/completions/fish/bitcoin-wallet.fish
  ''
  + lib.optionalString withGui ''
    installShellCompletion --fish contrib/completions/fish/bitcoin-qt.fish
    install -Dm644 share/pixmaps/bitcoin256.png $out/share/icons/hicolor/256x256/apps/bitcoin.png
  '';

  cmakeEntries = {
    BUILD_BENCH = false;
    WITH_ZMQ = true;
    BUILD_TESTS = false;
    BUILD_FUZZ_BINARY = false;
  }
  // lib.optionalAttrs (!withWallet) {
    ENABLE_WALLET = false;
  }
  // lib.optionalAttrs withGui {
    BUILD_GUI = true;
  };

  nativeCheckInputs = [ python3 ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    homepage = "https://bitcoin.org/en/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
