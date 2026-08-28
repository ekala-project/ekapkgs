{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  beamPackages ? null,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gleam";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "gleam-lang";
    repo = "gleam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-974B+22Lvd7KB9M0yuuxkolLtRmg42NrAX5CIrIc3Ac=";
  };

  cargoHash = "sha256-as+2oyOpGA71oPDGTuZhfPccr8AjsUZJFtnRLYRxFOI=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional (beamPackages != null) beamPackages.erlang;

  checkFlags = [
    "--skip=tests::echo::echo_dict"
    "--skip=tests::escript_success_with_dependency"
    "--skip=tests::all_files_have_copyright_notice"
  ];

  meta = {
    description = "Statically typed language for the Erlang VM";
    mainProgram = "gleam";
    homepage = "https://gleam.run/";
    changelog = "https://github.com/gleam-lang/gleam/blob/v${finalAttrs.version}/changelog/v${lib.versions.majorMinor finalAttrs.version}.md";
    license = lib.licenses.asl20;
  };
})
