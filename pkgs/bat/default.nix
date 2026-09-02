{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  less,
  installShellFiles,
  makeWrapper,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bat";
  version = "0.26.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "bat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IbTvFT37BFo0tKOiApDL9sT+/nMD33MO3TXuho+lF2c=";
  };

  cargoHash = "sha256-WRLCs1hrwFT3tya9CzKUuh5g+6fYqKDtv3yvDx8Wws8=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    makeWrapper
  ];

  buildInputs = [
    zlib
  ];

  postInstall = ''
    installManPage $releaseDir/build/bat-*/out/assets/manual/bat.1
    installShellCompletion $releaseDir/build/bat-*/out/assets/completions/bat.{bash,fish,zsh}
  '';

  postFixup = ''
    wrapProgram "$out/bin/bat" \
      --prefix PATH : "${lib.makeBinPath [ less ]}"
  '';

  checkFlags = [
    "--skip=alias_pager_disable_long_overrides_short"
    "--skip=config_read_arguments_from_file"
    "--skip=env_var_bat_paging"
    "--skip=pager_arg_override_env_noconfig"
    "--skip=pager_arg_override_env_withconfig"
    "--skip=pager_basic"
    "--skip=pager_basic_arg"
    "--skip=pager_env_bat_pager_override_config"
    "--skip=pager_env_pager_nooverride_config"
    "--skip=pager_more"
    "--skip=pager_most"
    "--skip=pager_overwrite"
    "--skip=file_with_invalid_utf8_filename"
  ];

  meta = {
    description = "Cat(1) clone with syntax highlighting and Git integration";
    homepage = "https://github.com/sharkdp/bat";
    changelog = "https://github.com/sharkdp/bat/raw/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "bat";
  };
})
