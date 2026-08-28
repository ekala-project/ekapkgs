{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  bash,
  coreutils,
  diffstat,
  diffutils,
  findutils,
  gawk,
  gnugrep,
  gnused,
  patch,
  perl,
  unixtools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quilt";
  version = "0.69";

  src = fetchurl {
    url = "mirror://savannah/quilt/quilt-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-VV3f/eIto8htHK9anB+4oVKsK4RzBDe9OcwIhJyfSFI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash
    coreutils
    diffstat
    diffutils
    findutils
    gawk
    gnugrep
    gnused
    patch
    perl
    unixtools.column
    unixtools.getopt
  ];

  strictDeps = true;

  configureFlags = [
    "--with-perl=${lib.getExe perl}"
  ];

  postInstall = ''
    wrapProgram $out/bin/quilt --prefix PATH : ${lib.makeBinPath finalAttrs.buildInputs}
  '';

  meta = {
    homepage = "https://savannah.nongnu.org/projects/quilt";
    description = "Easily manage large numbers of patches";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
