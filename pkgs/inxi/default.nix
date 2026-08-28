{
  lib,
  stdenv,
  fetchFromGitea,
  perl,
  perlPackages,
  makeWrapper,
  ps,
}:

let
  prefixPath = programs: "--prefix PATH ':' '${lib.makeBinPath programs}'";
  programs = [
    ps
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "inxi";
  version = "3.3.38-1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "smxi";
    repo = "inxi";
    tag = finalAttrs.version;
    hash = "sha256-+2NPQUn2A8Xy5ByKYS3MOcad6xXvkqcusWEMr7mkEwA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp inxi $out/bin/
    wrapProgram $out/bin/inxi \
      --set PERL5LIB "${perlPackages.makePerlPath (with perlPackages; [ CpanelJSONXS ])}" \
      ${prefixPath programs}
    mkdir -p $out/share/man/man1
    cp inxi.1 $out/share/man/man1/
  '';

  meta = {
    description = "Full featured CLI system information tool";
    homepage = "https://smxi.org/docs/inxi.htm";
    changelog = "https://codeberg.org/smxi/inxi/src/tag/${finalAttrs.version}/inxi.changelog";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "inxi";
  };
})
