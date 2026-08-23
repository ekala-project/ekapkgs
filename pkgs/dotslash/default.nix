{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dotslash";
  version = "0.5.7";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-VFesGum2xjknUuCwIojntdst5dmhvZb78ejJ2OG1FVI=";
  };

  cargoHash = "sha256-+FWDeR4AcFSFz0gGQ8VMvX68/F0yEm25cNfHeedqsWE=";
  doCheck = false; # http tests

  meta = {
    homepage = "https://dotslash-cli.com";
    description = "Simplified multi-platform executable deployment";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "dotslash";
    maintainers = [ ];
  };
})
