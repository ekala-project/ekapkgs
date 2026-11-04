{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  perl,
  readline,
  openssh,
}:

stdenv.mkDerivation rec {
  pname = "pdsh";
  version = "2.36";

  src = fetchurl {
    url = "https://github.com/chaos/pdsh/releases/download/pdsh-${version}/pdsh-${version}.tar.gz";
    hash = "sha256-pmEJXOUd1fsF45jPXQ4dYxVxI5WEQfbTUSvPGn0lxRc=";
  };

  buildInputs = [
    perl
    readline
    openssh
  ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    sed -i 's/m4_esyscmd(\[git describe.*/[${version}])/' configure.ac
  '';

  preConfigure = ''
    configureFlagsArray=(
      "--infodir=$out/share/info"
      "--mandir=$out/share/man"
      "--with-machines=/etc/pdsh/machines"
      "--with-readline"
      "--with-ssh"
      "--without-rsh"
      "--with-dshgroups"
      "--with-xcpu"
      "--disable-debug"
      '--with-rcmd-rank-list=ssh,krb4,exec,xcpu'
    )
  '';

  meta = {
    homepage = "https://github.com/chaos/pdsh";
    description = "High-performance, parallel remote shell utility";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    broken = true; # bool typedef conflict with modern glibc
  };
}
