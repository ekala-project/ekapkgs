{
  fetchFromGitHub,
  git,
  gnupg,
  makeWrapper,
  openssl,
  lib,
  stdenv,
  libxslt,
  docbook_xsl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-crypt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "AGWA";
    repo = "git-crypt";
    rev = finalAttrs.version;
    sha256 = "sha256-d5nMDFQkJY+obYkhvr8yT9mjlGEBWFLN5xGizJ9kwHw=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    libxslt
    makeWrapper
  ];

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace commands.cpp \
      --replace '(escape_shell_arg(our_exe_path()))' '= "git-crypt"'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ENABLE_MAN=yes"
    "DOCBOOK_XSL=${docbook_xsl}/share/xml/docbook-xsl-nons/manpages/docbook.xsl"
  ];

  env.CXXFLAGS = toString [
    "-DOPENSSL_API_COMPAT=0x30000000L"
  ];

  postFixup = ''
    wrapProgram $out/bin/git-crypt \
      --suffix PATH : ${
        lib.makeBinPath [
          git
          gnupg
        ]
      }
  '';

  meta = {
    homepage = "https://www.agwa.name/projects/git-crypt";
    description = "Transparent file encryption in git";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "git-crypt";
  };
})
