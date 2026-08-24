{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  withNativeTls ? true,
  stdenv,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "xh";
  version = "0.26.2";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EiwK5/+mAQc8P120E6gQa/6h5t4tijy7PcdF3RYQ10U=";
  };

  cargoHash = "sha256-fdqHUblEL9YFiYdWkonOWCdYCS9pZ+9uoiBoyK2qWB4=";

  buildFeatures = lib.optional withNativeTls "native-tls";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = lib.optionals (withNativeTls && !stdenv.hostPlatform.isDarwin) [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postInstall = ''
    installShellCompletion \
      completions/xh.{bash,fish} \
      --zsh completions/_xh

    installManPage doc/xh.1
    ln -s $out/share/man/man1/xh.1 $out/share/man/man1/xhs.1

    install -m444 -Dt $out/share/doc/xh README.md CHANGELOG.md

    ln -s $out/bin/xh $out/bin/xhs
  '';

  doCheck = false;
  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
    $out/bin/xhs --help > /dev/null
  '';

  meta = {
    description = "Friendly and fast tool for sending HTTP requests";
    homepage = "https://github.com/ducaale/xh";
    changelog = "https://github.com/ducaale/xh/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "xh";
  };
})
