{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  python3Packages,
  prefix ? "uutils-",
  buildMulticallBinary ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uutils-coreutils";
  version = "0.12.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    tag = finalAttrs.version;
    hash = "sha256-/Zi7/vh8hwniMxa+keYjW7KBeq3Xg2rqDlqyN2GOZN4=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-aLnQOXiQD9IL6ZiBi/ENF0aHud0kCyHZrnetkV+ZTFE=";
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    python3Packages.sphinx
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "SELINUX_ENABLED=0"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
    "BUILD_SPEC_FEATURE="
    "SKIP_UTILS=${lib.optionalString stdenv.hostPlatform.isStatic "stdbuf"}"
  ]
  ++ lib.optionals (prefix != null) [
    "PROG_PREFIX=${prefix}"
  ]
  ++ lib.optionals buildMulticallBinary [
    "MULTICALL=y"
  ];

  env = {
    CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;
    LN = "ln -sf";
  };

  doCheck = false;

  meta = {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    changelog = "https://github.com/uutils/coreutils/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
