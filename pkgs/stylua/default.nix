{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylua";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = "stylua";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-C0X7IdYqs/hhSX96XWVyk7rfQNd9DjYxYgHL34cI+3g=";
  };

  cargoHash = "sha256-m31oocBkx4i2KxM0YC1omVWtypFi7iEoDVlXgT93iSI=";

  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = [
    "lua54"
    "luajit"
    "luau"
  ];

  meta = {
    description = "Opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "stylua";
  };
})
