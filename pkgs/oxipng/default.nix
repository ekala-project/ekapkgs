{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxipng";
  version = "10.2.1";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NWDd56sZ/7W8cq9P3o8ifjLhyR+ZHEYrh1fUbyGYhBQ=";
  };

  cargoHash = "sha256-9DD1EHNtxLN3vwJQFIdibw1SnEgKHlCZAqq7GkDSQh4=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    homepage = "https://github.com/shssoichiro/oxipng";
    description = "Multithreaded lossless PNG compression optimizer";
    license = lib.licenses.mit;
    mainProgram = "oxipng";
  };
})
