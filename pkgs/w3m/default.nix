{
  lib,
  stdenv,
  fetchFromSourcehut,
  ncurses,
  boehmgc,
  gettext,
  zlib,
  sslSupport ? true,
  openssl,
  graphicsSupport ? !stdenv.hostPlatform.isDarwin,
  imlib2,
  x11Support ? graphicsSupport,
  libX11,
  perl,
  man,
  pkg-config,
  buildPackages,
  w3m,
  updateAutotoolsGnuConfigScriptsHook,
}:

let
  mktable = buildPackages.stdenv.mkDerivation {
    name = "w3m-mktable";
    inherit (w3m) src;
    nativeBuildInputs = [
      pkg-config
      boehmgc
    ];
    makeFlags = [ "mktable" ];
    installPhase = ''
      install -D mktable $out/bin/mktable
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "w3m";
  version = "0.5.6";

  src = fetchFromSourcehut {
    owner = "~rkta";
    repo = "w3m";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VJztcvcmmA8f5RJ+NEYjPE8CGEfCRRjQ+fuF0UpY+sA=";
  };

  env = {
    PERL = "${perl}/bin/perl";
    MAN = "${man}/bin/man";
    LIBS = lib.optionalString x11Support "-lX11";
  };

  makeFlags = [ "AR=${stdenv.cc.bintools.targetPrefix}ar" ];

  postPatch = lib.optionalString (stdenv.hostPlatform != stdenv.buildPlatform) ''
    ln -s ${mktable}/bin/mktable mktable
    sed -i -e 's!mktable.*:.*!mktable:!' Makefile.in
  '';

  nativeBuildInputs = [
    pkg-config
    gettext
    updateAutotoolsGnuConfigScriptsHook
  ];
  buildInputs = [
    ncurses
    boehmgc
    zlib
  ]
  ++ lib.optional sslSupport openssl
  ++ lib.optional graphicsSupport imlib2
  ++ lib.optional x11Support libX11;

  postInstall = lib.optionalString graphicsSupport ''
    ln -s $out/libexec/w3m/w3mimgdisplay $out/bin
  '';

  hardeningDisable = [ "format" ];

  configureFlags = [
    "--with-ssl=${openssl.dev}"
    "--with-gc=${boehmgc.dev}"
    "CFLAGS=-std=gnu17"
  ]
  ++ lib.optional graphicsSupport "--enable-image=${lib.optionalString x11Support "x11,"}fb"
  ++ lib.optional (graphicsSupport && !x11Support) "--without-x";

  preConfigure = ''
    substituteInPlace ./configure --replace "/lib /usr/lib /usr/local/lib /usr/ucblib /usr/ccslib /usr/ccs/lib /lib64 /usr/lib64" /no-such-path
    substituteInPlace ./configure --replace /usr /no-such-path
  '';

  outputs = [
    "out"
    "man"
  ];

  enableParallelBuilding = false;

  meta = {
    homepage = "https://git.sr.ht/~rkta/w3m";
    description = "Text-mode web browser";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "w3m";
  };
})
