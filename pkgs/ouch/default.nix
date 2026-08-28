{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  bzip2,
  bzip3 ? null,
  xz,
  git,
  zlib,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ouch";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = finalAttrs.version;
    hash = "sha256-fxBalMi5xdLNBnd5VIdAYDIjbSBrOPrmpKlKW1DmbxQ=";
  };

  cargoHash = "sha256-kYef8Xsi1gO0V2yXHiTkPi2rFjECw3jjhADSMhhu5zg=";

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    rustPlatform.bindgenHook
  ];

  nativeCheckInputs = [
    git
  ];

  buildInputs = [
    bzip2
    xz
    zlib
    zstd
  ]
  ++ lib.optionals (bzip3 != null) [
    bzip3
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "use_zlib"
    "use_zstd_thin"
    "zstd/pkg-config"
  ]
  ++ lib.optionals (bzip3 != null) [ "bzip3" ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch --nushell artifacts/ouch.nu
  '';

  env.OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = {
    description = "Command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.all;
    mainProgram = "ouch";
  };
})
