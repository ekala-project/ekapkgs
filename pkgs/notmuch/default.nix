{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  gnupg,
  xapian,
  gmime,
  sfsexp,
  talloc,
  zlib,
  doxygen,
  perl,
  texinfo,
  python3,
  emacs,
  ruby,
  which,
  dtach,
  openssl,
  bash,
  gdb,
  man,
  git,
  makeWrapper,
  buildEnv,
  withEmacs ? false,
  withRuby ? false,
  withSfsexp ? true,
  withVim ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notmuch";
  version = "0.40";

  src = fetchurl {
    url = "https://notmuchmail.org/releases/notmuch-${finalAttrs.version}.tar.xz";
    hash = "sha256-S0MUu/HCAp/feTY35se7FcGxcw0ivpqgSAPJjFu8RG8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/notmuch/notmuch/commit/f5e58cdb9b93b10ac32379b36b452532a32b8ece.patch";
      hash = "sha256-x+WHarE752IQzic/CTT26YuSi5Oox3lcQJP1FYNR6AE=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    doxygen
    python3.pkgs.sphinx
    texinfo
    python3.pkgs.cffi
  ]
  ++ lib.optional withEmacs emacs
  ++ lib.optional withRuby ruby
  ++ lib.optional withSfsexp makeWrapper;

  buildInputs = [
    gnupg
    xapian
    gmime
    talloc
    zlib
    perl
    python3
  ]
  ++ lib.optional withRuby ruby
  ++ lib.optional withSfsexp sfsexp;

  postPatch = ''
    patchShebangs configure test/

    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"

    substituteInPlace bindings/Makefile.local \
      --replace 'CFLAGS="$(CFLAGS) -pipe -fno-plt -fPIC"' ""
  '';

  configureFlags = [
    "--zshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
    "--bashcompletiondir=${placeholder "out"}/share/bash-completion/completions"
    "--infodir=${placeholder "info"}/share/info"
    "--without-emacs"
  ]
  ++ lib.optional (!withRuby) "--without-ruby";

  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];

  outputs = [
    "out"
    "man"
    "info"
  ];

  postBuild = lib.optionalString withSfsexp ''
    patchShebangs notmuch-git
  '';

  doCheck = false;

  installTargets = [
    "install"
    "install-man"
    "install-info"
  ];

  postInstall = lib.optionalString withSfsexp ''
    cp notmuch-git $out/bin/notmuch-git
    wrapProgram $out/bin/notmuch-git --prefix PATH : $out/bin:${lib.getBin git}/bin
  '';

  meta = {
    description = "Mail indexer";
    homepage = "https://notmuchmail.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "notmuch";
  };
})
