{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  rustPlatform,
  rustc,
  cargo,
  installShellFiles,
  libuuid,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "taskwarrior";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "taskwarrior";
    tag = "v${finalAttrs.version}";
    hash = "sha256-00HiGju4pIswx8Z+M+ATdBSupiMS2xIm2ZnE52k/RwA=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "${finalAttrs.pname}-${finalAttrs.version}-cargo-deps";
    inherit (finalAttrs) src;
    hash = "sha256-trc5DIWf68XRBSMjeG/ZchuwFA56wJnLbqm17gE+jYQ=";
  };

  postUnpack = ''
    export CARGO_HOME=$PWD/.cargo
  '';

  failingTests = [
    "bash_completion.test.py"
  ];

  preConfigure = ''
    patchShebangs test
  ''
  + lib.optionalString (builtins.length finalAttrs.failingTests > 0) ''
    substituteInPlace test/CMakeLists.txt \
      ${lib.concatMapStringsSep "\\\n  " (t: "--replace-fail ${t} '' ") finalAttrs.failingTests}
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    rustPlatform.cargoSetupHook
    rustc
    cargo
    installShellFiles
  ];

  buildInputs = [
    libuuid
  ];

  doCheck = true;

  preCheck = ''
    make test_runner
  '';

  nativeCheckInputs = [
    python3
  ];

  postInstall = ''
    installShellCompletion --cmd task \
      --bash $out/share/doc/task/scripts/bash/task.sh \
      --fish $out/share/doc/task/scripts/fish/task.fish
    rm -r $out/share/doc/task/scripts/bash
    rm -r $out/share/doc/task/scripts/fish
    mkdir -p $out/share/vim-plugins
    mv $out/share/doc/task/scripts/vim $out/share/vim-plugins/task
    mkdir -p $out/share/nvim
    ln -s $out/share/vim-plugins/task $out/share/nvim/site
  '';

  meta = {
    changelog = "https://github.com/GothenburgBitFactory/taskwarrior/releases/tag/${finalAttrs.src.tag}";
    description = "Highly flexible command-line tool to manage TODO lists";
    homepage = "https://taskwarrior.org";
    license = lib.licenses.mit;
    mainProgram = "task";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
