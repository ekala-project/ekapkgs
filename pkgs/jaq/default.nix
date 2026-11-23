{
  lib,
  rustPlatform,
  fetchFromGitHub,
  jotdown ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jaq";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "01mf02";
    repo = "jaq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1WFGrORD70f9cB34p0pwcOHiqMR5DfdccoxANqkibzk=";
  };

  cargoHash = "sha256-Fpeu6NX9zRX4rAVN9F/zQJE6FX7DHCiMFImIFlsKYqo=";

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
    mainProgram = "jaq";
  };
})
