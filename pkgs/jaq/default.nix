{
  lib,
  rustPlatform,
  fetchFromGitHub,
  jotdown ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jaq";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yAwLcPwfW5UH+PCCrsFaM0Nuk1S5QONLsNgvVCBLX8=";
  };

  cargoHash = "sha256-5+IBUOTO7XNWogQBNEt8XydLZ1xTvldvx5lIfh7K0QA=";

  nativeBuildInputs = lib.optional (jotdown != null) jotdown;

  postBuild = lib.optionalString (jotdown != null) ''
    pushd docs || true
    make jaq.1
    popd
  '';

  postInstall = lib.optionalString (jotdown != null) ''
    install -D docs/jaq.1 -t $out/share/man/man1
  '';

  meta = {
    description = "Jq clone focused on correctness, speed and simplicity";
    homepage = "https://github.com/01mf02/jaq";
    changelog = "https://github.com/01mf02/jaq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jaq";
  };
})
