{
  fetchFromGitHub,
  lib,
  makeWrapper,
  rustPlatform,
  wget,
  fzf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "navi";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zvqxVu147u/m/4B3fhbuQ46txGMrlgQv9d4GGiR8SoQ=";
  };

  cargoHash = "sha256-tQCm8KMVWo6KiKVOMDitHtDXwYGM7INXcT+7fEEiIiI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${
        lib.makeBinPath [
          wget
          fzf
        ]
      }
  '';

  checkFlags = [
    "--skip=test_parse_variable_line"
  ];

  meta = {
    description = "Interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "navi";
  };
})
