{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxipng";
  version = "10.1.1";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G06GAlxEVOqt2xHq+JOLSYbsa++aArbu+sb0ypQn9u4=";
  };

  cargoHash = "sha256-gRWDpxZGy01lWgCIse4Tf7gjwxzosozONB3LD5pX5KQ=";

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
