{
  lib,
  stdenv,
  acl,
  binutils-unwrapped-all-targets,
  bzip2,
  cdrkit,
  colordiff,
  coreutils,
  cpio,
  diffutils,
  docutils,
  dtc,
  e2fsprogs,
  fetchurl,
  file,
  findutils,
  gettext,
  gnutar,
  gzip,
  help2man,
  html2text,
  installShellFiles,
  libarchive,
  libxmlb,
  lz4,
  lzip,
  openssl,
  pgpdump,
  python3,
  sng,
  sqlite,
  squashfsTools,
  unzip,
  xxd,
  xz,
  zip,
  zstd,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "diffoscope";
  version = "326";
  pyproject = true;

  src = fetchurl {
    url = "https://diffoscope.org/archive/diffoscope-${version}.tar.bz2";
    hash = "sha256-Km0CvLx8BQ44Nwzxd9kHVFgVOnWPc+vly3ThcENGMOQ=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    ./ignore_links.patch
  ];

  postPatch = ''
    # When generating manpage, use the installed version
    substituteInPlace doc/Makefile --replace-fail "../bin" "$out/bin"
  '';

  nativeBuildInputs = [
    docutils
    help2man
    installShellFiles
  ];

  build-system = with python3.pkgs; [ setuptools ];

  pythonPath = lib.filter (lib.meta.availableOn stdenv.hostPlatform) (
    [
      acl
      binutils-unwrapped-all-targets
      bzip2
      cdrkit
      colordiff
      coreutils
      cpio
      diffutils
      dtc
      e2fsprogs
      file
      findutils
      gettext
      gnutar
      gzip
      html2text
      libarchive
      libxmlb
      lz4
      lzip
      openssl
      pgpdump
      sng
      sqlite
      squashfsTools
      unzip
      xxd
      xz
      zip
      zstd
    ]
    ++ (with python3.pkgs; [
      argcomplete
      defusedxml
      jsbeautifier
      jsondiff
      progressbar
      pypdf
      python-magic
    ])
  );

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ] ++ pythonPath;

  pytestFlags = [
    "-vv"
  ];

  postInstall = ''
    make -C doc
    installManPage doc/diffoscope.1
  '';

  # libarchive-c, python-debian, pyxattr, rpm, tlsh not available
  pythonRemoveDeps = [
    "libarchive-c"
    "python-debian"
    "pyxattr"
    "rpm"
    "tlsh"
  ];

  disabledTests = [
    "test_sbin_added_to_path"
    "test_diff_meta"
    "test_diff_meta2"
    "test_item3_deflate_llvm_bitcode"
    "test_non_unicode_filename"
  ];

  meta = {
    description = "Perform in-depth comparison of files, archives, and directories";
    homepage = "https://diffoscope.org/";
    changelog = "https://diffoscope.org/news/diffoscope-${version}-released/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "diffoscope";
  };
}
