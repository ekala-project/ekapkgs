{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typos";
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "typos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTLj3plODTTO6MW77XQmc1LWaboXdEHVciXux/8kud4=";
  };

  cargoHash = "sha256-vLEefaHLP5mx80oQujcFZWq1kn1V4Ycx+2TWXOBHhNo=";

  preCheck = ''
    export LC_ALL=C.UTF-8
  '';

  postCheck = ''
    unset LC_ALL
  '';

  doInstallCheck = true;

  meta = {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
  };
})
