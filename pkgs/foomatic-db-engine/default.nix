{
  lib,
  perlPackages,
  fetchFromGitHub,
  withCupsAccess ? false,
  cups,
  cups-filters ? null,
  curl,
  withSocketAccess ? false,
  netcat-gnu ? null,
  withSMBAccess ? false,
  samba ? null,
  autoconf,
  automake,
  file,
  makeWrapper,
}:

perlPackages.buildPerlPackage rec {
  pname = "foomatic-db-engine";
  version = "0-unstable-2026-04-13";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "foomatic-db-engine";
    rev = "e4e7b9cd28ba160428f82bc5234559d1f50e5c42";
    hash = "sha256-wpGFGr2H2adN4AVrYBNc+f4nE9x7OtzAxF5PkzmieXc=";
  };

  outputs = [ "out" ];

  propagatedBuildInputs = [
    perlPackages.Clone
    perlPackages.DBI
    perlPackages.XMLLibXML
  ];

  buildInputs = [
    curl
  ]
  ++ lib.optionals withCupsAccess [
    cups
    cups-filters
  ]
  ++ lib.optional withSocketAccess netcat-gnu
  ++ lib.optional withSMBAccess samba;

  nativeBuildInputs = [
    autoconf
    automake
    file
    makeWrapper
  ];

  prePatch = ''
    sed -Ei 's|^(S?BINSEARCHPATH=).+$|\1"@PATH@"|g' configure.ac
    substituteInPlace configure.ac --subst-var PATH
    touch Makefile.PL
  '';

  preConfigure = ''
    ./make_configure
  '';

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "LIBDIR=${placeholder "out"}/share/foomatic"
    "PERLPREFIX=${placeholder "out"}"
  ];

  postFixup = ''
    for bin in "${placeholder "out"}/bin"/*; do
      test '!' -L "$bin" || continue
      wrapProgram "$bin" --set PERL5LIB "$PERL5LIB"
    done
  '';

  doCheck = false;

  meta = {
    changelog = "https://github.com/OpenPrinting/foomatic-db-engine/blob/${src.rev}/ChangeLog";
    description = "OpenPrinting printer support database engine";
    downloadPage = "https://www.openprinting.org/download/foomatic/";
    homepage = "https://openprinting.github.io/projects/02-foomatic/";
    license = lib.licenses.gpl2Only;
    longDescription = ''
      Foomatic's database engine generates PPD files
      from the data in Foomatic's XML database.
      It also contains scripts to directly
      generate print queues and handle jobs.
    '';
  };
}
