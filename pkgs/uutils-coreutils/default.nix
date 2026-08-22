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
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    tag = finalAttrs.version;
    hash = "sha256-bqMrYVFa21Tu3t2Y5na9gFYr6AkklSnszbX8vKxI4gg=";
  };

  postPatch = ''
    rm .cargo/config.toml
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-7ROe9xrFcaXWYxoe9lfAfZxDxPcrETU8Mcj2HsdoqpA=";
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
    maintainers = [ ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
