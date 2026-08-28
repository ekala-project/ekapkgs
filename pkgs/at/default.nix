{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bison,
  flex,
  pam,
  perl,
  sendmailPath ? "/run/wrappers/bin/sendmail",
  atWrapperPath ? "/run/wrappers/bin/at",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "at";
  version = "3.2.5";

  src = fetchurl {
    url = "mirror://debian/pool/main/a/at/at_${finalAttrs.version}.orig.tar.gz";
    hash = "sha256-uwZrOJ18m7nYSjVzgDK4XDDLp9lJ91gZKtxyyUd/07g=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/riscv/riscv-poky/master/meta/recipes-extended/at/at/0001-remove-glibc-assumption.patch";
      hash = "sha256-1UobqEZWoaq0S8DUDPuI80kTx0Gut2/VxDIwcKeGZOY=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile.in \
      --replace ' -o root ' ' ' \
      --replace ' -g root ' ' ' \
      --replace ' -o $(DAEMON_USERNAME) ' ' ' \
      --replace ' -o $(DAEMON_GROUPNAME) ' ' ' \
      --replace ' -g $(DAEMON_GROUPNAME) ' ' ' \
      --replace '$(DESTDIR)$(etcdir)' "$out/etc" \
      --replace '$(DESTDIR)$(ATJOB_DIR)' "$out/var/spool/atjobs" \
      --replace '$(DESTDIR)$(ATSPOOL_DIR)' "$out/var/spool/atspool" \
      --replace '$(DESTDIR)$(LFILE)' "$out/var/spool/atjobs/.SEQ" \
      --replace 'chown' '# skip chown' \
      --replace '6755' '0755'
  '';

  nativeBuildInputs = [
    bison
    flex
    perl
  ];

  buildInputs = [ pam ];

  preConfigure = ''
    export SENDMAIL=${sendmailPath}
    substituteInPlace ./configure --replace "test -d /var/run" "true"
  '';

  configureFlags = [
    "--with-etcdir=/etc/at"
    "--with-jobdir=/var/spool/atjobs"
    "--with-atspool=/var/spool/atspool"
    "--with-daemon_username=atd"
    "--with-daemon_groupname=atd"
  ];

  doCheck = true;

  postInstall = ''
    sed -i "6i test -x ${atWrapperPath} && exec ${atWrapperPath} -qb now  # exec doesn't return" "$out/bin/batch"
  '';

  meta = {
    description = "Classical Unix `at' job scheduling command";
    license = lib.licenses.gpl2Plus;
    homepage = "https://tracker.debian.org/pkg/at";
    platforms = lib.platforms.linux;
    mainProgram = "at";
  };
})
