{
  lib,
  stdenv,
  acl,
  e2fsprogs,
  fetchFromGitHub,
  libb2,
  lz4,
  openssh,
  openssl,
  python3,
  xxhash,
  zstd,
  installShellFiles,
}:

let
  python = python3;
in
python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "borgbackup";
  version = "1.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borgbackup";
    repo = "borg";
    tag = finalAttrs.version;
    hash = "sha256-jkFF+nNZL8lEXgworFLNoEKTr2LgCat1fOFlTh7AWs4=";
  };

  postPatch = ''
    # sandbox does not support setuid/setgid/sticky bits
    substituteInPlace src/borg/testsuite/archiver.py \
      --replace-fail "0o4755" "0o0755"
  '';

  build-system = with python.pkgs; [
    cython
    setuptools-scm
    pkgconfig
  ];

  nativeBuildInputs = [
    # shell completions
    installShellFiles
  ];

  buildInputs = [
    libb2
    lz4
    xxhash
    zstd
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
  ];

  dependencies = with python.pkgs; [
    msgpack
    packaging
  ];

  makeWrapperArgs = [
    ''--prefix PATH ':' "${openssh}/bin"''
  ];

  postInstall = ''
    installShellCompletion --cmd borg \
      --bash scripts/shell_completions/bash/borg \
      --fish scripts/shell_completions/fish/borg.fish \
      --zsh scripts/shell_completions/zsh/_borg
  '';

  nativeCheckInputs = with python.pkgs; [
    e2fsprogs
    py
    pytest-benchmark
    pytest-xdist
    pytestCheckHook
  ];

  pytestFlags = [
    "--benchmark-skip"
    "--pyargs"
    "borg.testsuite"
  ];

  disabledTests = [
    # fuse: device not found, try 'modprobe fuse' first
    "test_fuse"
    "test_fuse_allow_damaged_files"
    "test_fuse_mount_hardlinks"
    "test_fuse_mount_options"
    "test_fuse_versions_view"
    "test_migrate_lock_alive"
    "test_readonly_mount"
    # Error: Permission denied while trying to write to /var/{,tmp}
    "test_get_cache_dir"
    "test_get_keys_dir"
    "test_get_security_dir"
    "test_get_config_dir"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tests create files with append-only flags that cause cleanup issues on macOS
    "test_extract_restores_append_flag"
    "test_file_status_excluded"
  ];

  preCheck = ''
    export HOME=$TEMP
  '';

  outputs = [
    "out"
  ];

  meta = {
    changelog = "https://github.com/borgbackup/borg/blob/${finalAttrs.src.rev}/docs/changes.rst";
    description = "Deduplicating archiver with compression and encryption";
    homepage = "https://www.borgbackup.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix; # Darwin and FreeBSD mentioned on homepage
    mainProgram = "borg";
  };
})
