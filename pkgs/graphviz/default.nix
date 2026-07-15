{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  buildPackages,
  cairo,
  expat,
  flex,
  fontconfig,
  gd,
  gts,
  libjpeg,
  libpng,
  libtool,
  makeWrapper,
  pango,
  bash,
  bison,
  libxrender,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphviz";
  version = "12.2.1";

  src = fetchFromGitLab {
    owner = "graphviz";
    repo = "graphviz";
    rev = finalAttrs.version;
    hash = "sha256-Uxqg/7+LpSGX4lGH12uRBxukVw0IswFPfpb2EkLsaiI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
    python3
    bison
    flex
  ];

  buildInputs = [
    libpng
    libjpeg
    expat
    fontconfig
    gd
    gts
    pango
    bash
    libxrender
  ];

  hardeningDisable = [ "fortify" ];

  configureFlags = [
    "--with-ltdl-lib=${libtool.lib}/lib"
    "--with-ltdl-include=${libtool}/include"
    "--with-x"
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  preAutoreconf = ''
    ./autogen.sh
  '';

  postPatch = ''
    substituteInPlace cmd/dot/Makefile.am --replace-fail \
      'if test "x$(DESTDIR)" = "x" -a "x$(build)" = "x$(host)"; then if test -x $(bindir)/dot$(EXEEXT); then if test -x /sbin/ldconfig; then /sbin/ldconfig 2>/dev/null; fi; cd $(bindir); ./dot$(EXEEXT) -c; else cd $(bindir); ./dot_static$(EXEEXT) -c; fi; fi' \
      '${lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
        if test -x $(bindir)/dot$(EXEEXT); then \
          cd $(bindir); ${stdenv.hostPlatform.emulator buildPackages} ./dot$(EXEEXT) -c; \
        else \
          cd $(bindir); ${stdenv.hostPlatform.emulator buildPackages} ./dot_static$(EXEEXT) -c; \
        fi
      ''}'
  '';

  postFixup = ''
    substituteInPlace $out/bin/vimdot \
      --replace-warn '"/usr/bin/vi"' '"$(command -v vi)"' \
      --replace-warn '"/usr/bin/vim"' '"$(command -v vim)"' \
      --replace-warn /usr/bin/vimdot $out/bin/vimdot

    wrapProgram $out/bin/vimdot --prefix PATH : "$out/bin"
  '';

  meta = {
    homepage = "https://graphviz.org";
    description = "Graph visualization tools";
    license = lib.licenses.epl10;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
