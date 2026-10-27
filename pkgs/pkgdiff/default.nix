{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  wdiff,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.8";
  pname = "pkgdiff";

  src = fetchFromGitHub {
    owner = "lvc";
    repo = "pkgdiff";
    tag = finalAttrs.version;
    sha256 = "sha256-/xhORi/ZHC4B2z6UYPOvDzfgov1DcozRjX0K1WYrqXM=";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  dontBuild = true;

  makeFlags = [ "prefix=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/pkgdiff --prefix PATH : ${lib.makeBinPath [ wdiff ]}
  '';

  meta = {
    description = "Tool for visualizing changes in Linux software packages";
    homepage = "https://lvc.github.io/pkgdiff/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    mainProgram = "pkgdiff";
  };
})
