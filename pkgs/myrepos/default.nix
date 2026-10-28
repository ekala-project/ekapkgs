{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "myrepos";
  version = "1.20180726";

  src = fetchFromGitHub {
    owner = "joeyh";
    repo = "myrepos";
    tag = finalAttrs.version;
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/mr \
      --prefix PERL5LIB : "${perl}/lib/perl5"
  '';

  meta = {
    description = "Tool to manage all your version control repos";
    homepage = "https://myrepos.branchable.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    mainProgram = "mr";
  };
})
