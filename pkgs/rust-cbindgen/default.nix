{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-cbindgen";
  version = "0.29.4";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "cbindgen";
    rev = "v${finalAttrs.version}";
    hash = "sha256-leeHOwpzXuzg2cTjXehBnCsS+dvU4eIIFtWKeCee20U=";
  };

  cargoHash = "sha256-f6YoDoiVoh0BVPYHFO1FsdI4OCsF+LY72QaD57StdIQ=";

  checkFlags = [
    "--skip=test_expand"
    "--skip=test_bitfield"
    "--skip=lib_default_uses_debug_build"
    "--skip=lib_explicit_debug_build"
    "--skip=lib_explicit_release_build"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=test_body"
  ];

  meta = {
    changelog = "https://github.com/mozilla/cbindgen/blob/v${finalAttrs.version}/CHANGES";
    description = "Project for generating C bindings from Rust code";
    mainProgram = "cbindgen";
    homepage = "https://github.com/mozilla/cbindgen";
    license = lib.licenses.mpl20;
  };
})
