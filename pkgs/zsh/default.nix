{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  perl,
  groff,
  util-linuxMinimal,
  texinfo,
  ncurses,
  pcre2,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh";
  version = "5.9.1";

  outputs = [
    "out"
    "doc"
    "info"
    "man"
  ];

  src = fetchurl {
    url = "mirror://sourceforge/zsh/zsh-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-XSC+wD+YHcTpoJ7CRedBU4j/ZB95xcXEFrUELljYKA0=";
  };

  patches = [ ./tz_completion.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
    groff
    texinfo
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linuxMinimal
    # TODO(ekapkgs): yodl missing, man pages may not build
  ];

  buildInputs = [
    ncurses
    pcre2
  ];

  env.PCRE_CONFIG = lib.getExe' (lib.getDev pcre2) "pcre2-config";

  configureFlags = [
    "--enable-maildir-support"
    "--enable-multibyte"
    "--with-tcsetpgrp"
    "--enable-pcre"
    "--enable-zshenv=${placeholder "out"}/etc/zshenv"
    "--disable-site-fndir"
  ];

  postInstall = ''
    make install.info install.html
    mkdir -p $out/etc/
    cat > $out/etc/zshenv <<EOF
    if test -r /etc/zshenv; then
      . /etc/zshenv
    fi
    EOF
    $out/bin/zsh -c "zcompile $out/etc/zshenv"
    mv $out/etc/zshenv $out/etc/zshenv_zwc_is_used

    rm -f $out/bin/zsh-${finalAttrs.version}
    mkdir -p $out/share/doc/
    mv $out/share/zsh/htmldoc $out/share/doc/zsh-${finalAttrs.version}
  '';

  postFixup = ''
    HOST_PATH=$out/bin:$HOST_PATH patchShebangs --host $out/share/zsh/*/functions
  '';

  passthru.shellPath = "/bin/zsh";

  meta = {
    description = "Z shell";
    license = lib.licenses.mit;
    homepage = "https://www.zsh.org/";
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "zsh";
  };
})
