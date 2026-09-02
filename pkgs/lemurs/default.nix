{
  fetchFromGitHub,
  lib,
  linux-pam,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lemurs";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dtAmgzsUhn3AfafWbCaaog0S1teIy+8eYtaHBhvLfLI=";
  };

  cargoHash = "sha256-XoGtIHYCGXNuwnpDTU7NbZAs6rCO+69CAG89VCv9aAc=";

  buildInputs = [
    linux-pam
  ];

  postInstall = ''
    install -Dm0755 extra/xsetup.sh "$out/etc/xsetup.sh"
  '';

  meta = {
    description = "Customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "lemurs";
  };
})
