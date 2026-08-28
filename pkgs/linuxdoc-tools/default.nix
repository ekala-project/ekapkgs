{
  stdenv,
  lib,
  makeWrapper,
  fetchFromGitLab,
  perl,
  flex,
  gnused,
  coreutils,
  which,
  opensp,
  groff,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linuxdoc-tools";
  version = "0.9.86";

  src = fetchFromGitLab {
    owner = "agmartin";
    repo = "linuxdoc-tools";
    rev = finalAttrs.version;
    hash = "sha256-AsTlrjTYuuLB2jF0zKPVrxOZ2ygUIyMJFV6qDd7ODwA=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  configureFlags = [
    "--enable-docs=txt info lyx html rtf"
  ];

  env.LEX = "flex";

  postInstall = ''
    wrapProgram $out/bin/linuxdoc \
      --prefix PATH : "${
        lib.makeBinPath [
          groff
          opensp
        ]
      }:$out/bin" \
      --prefix PERL5LIB : "$out/share/linuxdoc-tools/"
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    pushd doc/example
    substituteInPlace Makefile \
      --replace "COMMAND=linuxdoc" "COMMAND=$out/bin/linuxdoc" \
      --replace '.tex .dvi .ps .pdf' ""
    make
    popd
  '';

  nativeBuildInputs = [
    flex
    which
    makeWrapper
  ];

  buildInputs = [
    opensp
    groff
    texinfo
    perl
    gnused
    coreutils
  ];

  meta = {
    description = "Toolset for processing LinuxDoc DTD SGML files";
    homepage = "https://gitlab.com/agmartin/linuxdoc-tools";
    license = with lib.licenses; [
      gpl3Plus
      mit
    ];
    platforms = lib.platforms.linux;
  };
})
