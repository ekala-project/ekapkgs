{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hexyl";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = "hexyl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1FlFvVgv4SslHtwXvHIE5aUXlDsUK4YFBtIKgsv/eB0=";
  };

  cargoHash = "sha256-/+0oRyA9gfucfBTdkN9Q5eUZOWNDIAOj634yAc7Hzn0=";

  meta = {
    description = "Command-line hex viewer";
    homepage = "https://github.com/sharkdp/hexyl";
    changelog = "https://github.com/sharkdp/hexyl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "hexyl";
  };
})
