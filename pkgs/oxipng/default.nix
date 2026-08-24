{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxipng";
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GwpXPkEkGqF55YOszXze0iZPi+sjaxtpcKpznc9CQbI=";
  };

  cargoHash = "sha256-rxb2qKS9sNM/+65YVhZ0jUvvZf8lfDJgU3ltY2Vht00=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    mainProgram = "oxipng";
    maintainers = [ ];
  };
})
