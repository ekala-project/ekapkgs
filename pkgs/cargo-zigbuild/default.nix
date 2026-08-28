{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  zig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-zigbuild";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-zigbuild";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y73aPGsrSAZVxNJ1r1lS9uXmfpAwthq6NW4urKS8ab0=";
  };

  cargoHash = "sha256-dt2s18B9RVwEBlun5cegoqfW1KYXFqjdScdc/Q2aDlI=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = {
    description = "Tool to compile Cargo projects with zig as the linker";
    mainProgram = "cargo-zigbuild";
    homepage = "https://github.com/rust-cross/cargo-zigbuild";
    changelog = "https://github.com/rust-cross/cargo-zigbuild/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
