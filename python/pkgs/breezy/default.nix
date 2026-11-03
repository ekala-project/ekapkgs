{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  configobj,
  cython,
  dulwich,
  fastbencode,
  fastimport,
  pygithub,
  libiconv,
  merge3,
  patiencediff,
  pyyaml,
  tzlocal,
  urllib3,
  launchpadlib,
  installShellFiles,
  pkgs,
  setuptools-gettext,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "breezy";
  version = "3.3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "breezy-team";
    repo = "breezy";
    tag = "brz-${version}";
    hash = "sha256-S8YHFEWiSnkBFO75jMuEcvVZSnoV9SGCH/Ueodq2zow=";
  };

  cargoDeps = pkgs.rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    installShellFiles
    pkgs.rustPlatform.cargoSetupHook
    cargo
    pkgs.rustc
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  build-system = [
    cython
    setuptools-gettext
    setuptools-rust
  ];

  dependencies = [
    configobj
    dulwich
    fastbencode
    merge3
    patiencediff
    pyyaml
    tzlocal
    urllib3
    launchpadlib
    fastimport
    pygithub
  ];

  # multiple failures on sandbox

  postInstall = ''
    wrapProgram $out/bin/brz --prefix PYTHONPATH : "$PYTHONPATH"

    # symlink for bazaar compatibility
    ln -s "$out/bin/brz" "$out/bin/bzr"

    installShellCompletion --cmd brz --bash contrib/bash/brz
  '';

  pythonImportsCheck = [
    "breezy"
    "breezy.bzr.rio"
  ];

  meta = {
    description = "Friendly distributed version control system";
    homepage = "https://www.breezy-vcs.org/";
    changelog = "https://github.com/breezy-team/breezy/blob/${src.tag}/doc/en/release-notes/brz-${lib.versions.majorMinor version}.txt";
    license = lib.licenses.gpl2Plus;
    mainProgram = "brz";
  };
}
