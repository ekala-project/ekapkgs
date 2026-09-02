{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  # asciidoc is not available (resolves to Haskell package in this repo)
  libxml2,
  libxslt,
  luajit ? null,
  docbook_xsl,
  pkg-config,
  coreutils,
  gnused,
  groff,
  docutils,
  gzip,
  bzip2,
  lzip,
  xz,
  zstd,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgit";
  version = "1.3.1";

  src = fetchurl {
    url = "https://git.zx2c4.com/cgit/snapshot/cgit-${finalAttrs.version}.tar.xz";
    sha256 = "c40fd71e120783d5e57d822208f3e17333cde2cd4baf3e7c8c75630b68afe12a";
  };

  gitSrc = fetchurl {
    url = "mirror://kernel/software/scm/git/git-2.54.0.tar.xz";
    hash = "sha256-9okWI2TBDeee+Jqo2/SHMesFfjTtu9IKylEM4BVGgaM=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with python3Packages; [
    python
    wrapPython
  ]);
  buildInputs = [
    openssl
    zlib
    libxml2
    libxslt
    docbook_xsl
  ]
  ++ lib.optionals (luajit != null) [
    luajit
  ];
  pythonPath = with python3Packages; [
    pygments
    markdown
  ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2.bin}/bin/bzip2"|' \
        -e 's|"lzip"|"${lzip}/bin/lzip"|' \
        -e 's|"xz"|"${xz.bin}/bin/xz"|' \
        -e 's|"zstd"|"${zstd}/bin/zstd"|' \
        -i ui-snapshot.c

    substituteInPlace filters/html-converters/man2html \
      --replace 'groff' '${groff}/bin/groff'

    substituteInPlace filters/html-converters/rst2html \
      --replace 'rst2html.py' '${docutils}/bin/rst2html.py'
  '';

  preBuild = ''
    mkdir -p git
    tar --strip-components=1 -xf "$gitSrc" -C git
  '';

  makeFlags = [
    "prefix=$(out)"
    "CGIT_SCRIPT_PATH=$(out)/cgit/"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  postInstall = ''
    wrapPythonProgramsIn "$out/lib/cgit/filters" "$out ''${pythonPath[*]}"

    for script in $out/lib/cgit/filters/*.sh $out/lib/cgit/filters/html-converters/txt2html; do
      wrapProgram $script --prefix PATH : '${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }'
    done
  '';

  stripDebugList = [ "cgit" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://git.zx2c4.com/cgit/about/";
    description = "Web frontend for git repositories";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
